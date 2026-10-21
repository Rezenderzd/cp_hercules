import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:cp4_hercules/models/investimento.dart';
import 'package:cp4_hercules/services/mercado_investimentos_service.dart';

String _bcb(String valor) => jsonEncode([
      {'data': '16/09/2026', 'valor': valor},
    ]);

String _brapi(String ticker) => jsonEncode({
      'results': [
        {
          'symbol': ticker,
          'historicalDataPrice': [
            {'date': 3, 'close': 8},
            {'date': 1, 'close': 10},
            {'date': 4, 'close': 11},
            {'date': 2, 'close': 12},
          ],
        },
      ],
    });

String _yahoo() => jsonEncode({
      'chart': {
        'result': [
          {
            'timestamp': [1, 2, 3, 4, 5],
            'indicators': {
              'quote': [
                {
                  'close': [99, 99, 99, 99, 99],
                },
              ],
              'adjclose': [
                {
                  'adjclose': [10, null, 12, 8, 11],
                },
              ],
            },
          },
        ],
        'error': null,
      },
    });

MockClient _cliente({
  bool bcbFalha = false,
  bool brapiFalha = false,
  bool yahooFalha = false,
  List<http.Request>? requisicoes,
}) {
  return MockClient((requisicao) async {
    requisicoes?.add(requisicao);
    final url = requisicao.url.toString();

    if (url.contains('api.bcb.gov.br')) {
      if (bcbFalha) return http.Response('erro', 500);
      if (url.contains('sgs.432/')) return http.Response(_bcb('15.00'), 200);
      if (url.contains('sgs.4389/')) return http.Response(_bcb('14.90'), 200);
      if (url.contains('sgs.226/')) return http.Response(_bcb('0.1700'), 200);
    }

    if (url.contains('brapi.dev')) {
      if (brapiFalha) return http.Response('erro', 500);
      return http.Response(_brapi(requisicao.url.pathSegments.last), 200);
    }

    if (url.contains('finance.yahoo.com')) {
      if (yahooFalha) return http.Response('erro', 429);
      return http.Response(_yahoo(), 200);
    }

    return http.Response('não encontrado', 404);
  });
}

void main() {
  test('monta 3 opções de renda fixa e 3 ações: Itaú, Bradesco e Vivo', () async {
    final servico = MercadoInvestimentosService(cliente: _cliente());
    final resultado = await servico.buscarOpcoes();

    expect(resultado.fontesComFalha, isEmpty);
    expect(resultado.opcoes, hasLength(6));

    final porId = {for (final i in resultado.opcoes) i.id: i};
    expect(porId.keys, containsAll(['poupanca', 'tesouro-selic', 'cdb', 'itub4', 'bbdc4', 'vivt3']));
    expect(porId['tesouro-selic']!.rentabilidadePct, 15);
    expect(porId['cdb']!.rentabilidadePct, 14.9);
    expect(porId['poupanca']!.rentabilidadePct, closeTo(8.342992, 0.0001));

    for (final ticker in ['itub4', 'bbdc4', 'vivt3']) {
      final acao = porId[ticker]!;
      expect(acao.tipo, TipoInvestimento.acao);
      expect(acao.risco, RiscoInvestimento.alto);
      expect(acao.rentabilidadePct, closeTo(10, 0.0001));
      expect(acao.chanceDePrejuizoPct, closeTo(25, 0.0001));
      expect(acao.maiorQuedaPct, closeTo(33.3333, 0.001));
    }

    expect(porId['itub4']!.fonte, startsWith('brapi.dev'));
    expect(porId['bbdc4']!.fonte, startsWith('Yahoo Finance'));
    expect(porId['vivt3']!.fonte, startsWith('Yahoo Finance'));
  });

  test('Bradesco e Vivo usam o código .SA e o cabeçalho de navegador no Yahoo', () async {
    final requisicoes = <http.Request>[];
    final servico = MercadoInvestimentosService(cliente: _cliente(requisicoes: requisicoes));
    await servico.buscarOpcoes();

    final yahoo = requisicoes.where((r) => r.url.host.contains('yahoo')).toList();
    expect(yahoo.map((r) => r.url.pathSegments.last), containsAll(['BBDC4.SA', 'VIVT3.SA']));
    expect(yahoo.every((r) => r.headers['User-Agent'] == 'Mozilla/5.0'), isTrue);
  });

  test('se o Yahoo Finance falhar, renda fixa e Itaú continuam aparecendo', () async {
    final servico = MercadoInvestimentosService(cliente: _cliente(yahooFalha: true));
    final resultado = await servico.buscarOpcoes();

    expect(resultado.opcoes.map((i) => i.id), containsAll(['poupanca', 'tesouro-selic', 'cdb', 'itub4']));
    expect(resultado.opcoes, hasLength(4));
    expect(resultado.fontesComFalha, [MercadoInvestimentosService.fonteYahoo]);
  });

  test('se a brapi.dev falhar, só o Itaú sai da lista', () async {
    final servico = MercadoInvestimentosService(cliente: _cliente(brapiFalha: true));
    final resultado = await servico.buscarOpcoes();

    expect(resultado.opcoes, hasLength(5));
    expect(resultado.opcoes.any((i) => i.id == 'itub4'), isFalse);
    expect(resultado.fontesComFalha, [MercadoInvestimentosService.fonteBrapi]);
  });

  test('se o Banco Central falhar, as ações continuam aparecendo', () async {
    final servico = MercadoInvestimentosService(cliente: _cliente(bcbFalha: true));
    final resultado = await servico.buscarOpcoes();

    expect(resultado.opcoes, hasLength(3));
    expect(resultado.fontesComFalha, [MercadoInvestimentosService.fonteBancoCentral]);
  });
}
