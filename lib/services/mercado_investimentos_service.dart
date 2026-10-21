import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/utils/calculos_investimentos.dart';
import '../models/investimento.dart';
import 'investimentos_service.dart';

class _AcaoAcompanhada {
  final String ticker;
  final String nome;
  final String descricao;

  const _AcaoAcompanhada(this.ticker, this.nome, this.descricao);
}

class _ValorBcb {
  final double valor;
  final String data;

  const _ValorBcb(this.valor, this.data);
}

class MercadoInvestimentosService implements InvestimentosService {
  MercadoInvestimentosService({
    http.Client? cliente,
    this.tempoLimite = const Duration(seconds: 15),
  }) : _cliente = cliente ?? http.Client();

  final http.Client _cliente;
  final Duration tempoLimite;

  static const String fonteBancoCentral = 'Taxas do Banco Central';
  static const String fonteBrapi = 'Cotação do Itaú (brapi.dev)';
  static const String fonteYahoo = 'Cotações do Bradesco e da Vivo (Yahoo Finance)';

  static const int _serieMetaSelic = 432;
  static const int _serieCdi = 4389;
  static const int _serieTr = 226;

  static const _AcaoAcompanhada _itau = _AcaoAcompanhada(
    'ITUB4',
    'Itaú Unibanco (ITUB4)',
    'Ação do Itaú, o maior banco privado do país.',
  );

  static const List<_AcaoAcompanhada> _acoesYahoo = [
    _AcaoAcompanhada(
      'BBDC4',
      'Bradesco (BBDC4)',
      'Ação do Bradesco, banco dono da Bradesco Seguros.',
    ),
    _AcaoAcompanhada(
      'VIVT3',
      'Vivo (VIVT3)',
      'Ação da Telefônica Brasil, dona da marca Vivo.',
    ),
  ];

  @override
  Future<ResultadoInvestimentos> buscarOpcoes() async {
    final falhas = <String>[];

    final resultados = await Future.wait([
      _tentar(fonteBancoCentral, _buscarRendaFixa, falhas),
      _tentar(fonteBrapi, () async => [await _buscarAcaoBrapi(_itau)], falhas),
      _tentar(
        fonteYahoo,
        () => Future.wait(_acoesYahoo.map(_buscarAcaoYahoo)),
        falhas,
      ),
    ]);

    return ResultadoInvestimentos(
      opcoes: [for (final lista in resultados) ...lista],
      fontesComFalha: falhas,
    );
  }

  Future<List<Investimento>> _tentar(
    String fonte,
    Future<List<Investimento>> Function() buscar,
    List<String> falhas,
  ) async {
    try {
      return await buscar();
    } catch (erro) {
      debugPrint('Zena+ investimentos [$fonte]: $erro');
      falhas.add(fonte);
      return const [];
    }
  }

  Future<List<Investimento>> _buscarRendaFixa() async {
    final valores = await Future.wait([
      _ultimoValorBcb(_serieMetaSelic),
      _ultimoValorBcb(_serieCdi),
      _ultimoValorBcb(_serieTr),
    ]);
    final selic = valores[0];
    final cdi = valores[1];
    final tr = valores[2];

    final poupanca = rentabilidadePoupancaAnual(
      selicAnual: selic.valor,
      trMensal: tr.valor,
    );

    return [
      Investimento(
        id: 'poupanca',
        nome: 'Poupança',
        descricao: 'Dinheiro disponível na hora. O rendimento segue a regra '
            'oficial, calculada a partir da Selic e da TR.',
        tipo: TipoInvestimento.rendaFixa,
        rentabilidadePct: poupanca,
        risco: RiscoInvestimento.baixo,
        chanceDePrejuizoPct: 0,
        maiorQuedaPct: 0,
        garantia: 'Garantida pelo FGC até R\$ 250 mil por CPF, por instituição.',
        fonte: 'Banco Central: Selic e TR de ${tr.data}',
      ),
      Investimento(
        id: 'tesouro-selic',
        nome: 'Tesouro Selic',
        descricao: 'Título público que acompanha a taxa Selic. '
            'Comum para reserva de emergência.',
        tipo: TipoInvestimento.rendaFixa,
        rentabilidadePct: selic.valor,
        risco: RiscoInvestimento.baixo,
        chanceDePrejuizoPct: 0,
        maiorQuedaPct: 0,
        garantia: 'Garantido pelo Tesouro Nacional.',
        fonte: 'Banco Central: meta da Selic de ${selic.data}',
      ),
      Investimento(
        id: 'cdb',
        nome: 'CDB 100% do CDI',
        descricao: 'Você empresta ao banco e recebe 100% do CDI.',
        tipo: TipoInvestimento.rendaFixa,
        rentabilidadePct: cdi.valor,
        risco: RiscoInvestimento.baixo,
        chanceDePrejuizoPct: 0,
        maiorQuedaPct: 0,
        garantia: 'Garantido pelo FGC até R\$ 250 mil por CPF, por instituição.',
        fonte: 'Banco Central: CDI de ${cdi.data}',
      ),
    ];
  }

  Future<_ValorBcb> _ultimoValorBcb(int serie) async {
    final uri = Uri.parse(
      'https://api.bcb.gov.br/dados/serie/bcdata.sgs.$serie/dados/ultimos/1?formato=json',
    );
    final resposta = await _cliente.get(uri).timeout(tempoLimite);
    if (resposta.statusCode != 200) {
      throw Exception('Banco Central, série $serie: HTTP ${resposta.statusCode}');
    }

    final lista = jsonDecode(resposta.body) as List<dynamic>;
    if (lista.isEmpty) {
      throw Exception('Banco Central, série $serie: resposta vazia');
    }

    final item = lista.last as Map<String, dynamic>;
    final valor = double.parse('${item['valor']}'.replaceAll(',', '.'));
    return _ValorBcb(valor, '${item['data']}');
  }

  Future<Investimento> _buscarAcaoBrapi(_AcaoAcompanhada acao) async {
    final uri = Uri.parse(
      'https://brapi.dev/api/quote/${acao.ticker}?range=1y&interval=1d',
    );
    final resposta = await _cliente.get(uri).timeout(tempoLimite);
    if (resposta.statusCode != 200) {
      throw Exception('brapi.dev, ${acao.ticker}: HTTP ${resposta.statusCode}');
    }

    final corpo = jsonDecode(resposta.body) as Map<String, dynamic>;
    final resultados = corpo['results'] as List<dynamic>? ?? const [];
    if (resultados.isEmpty) {
      throw Exception('brapi.dev, ${acao.ticker}: sem resultados');
    }

    final dados = resultados.first as Map<String, dynamic>;
    final historico = (dados['historicalDataPrice'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList()
      ..sort((a, b) => _numero(a['date']).compareTo(_numero(b['date'])));

    final fechamentos = <double>[];
    for (final dia in historico) {
      final preco = _precoDoDia(dia);
      if (preco != null && preco > 0) {
        fechamentos.add(preco);
      }
    }

    return _montarAcao(acao, fechamentos, 'brapi.dev');
  }

  Future<Investimento> _buscarAcaoYahoo(_AcaoAcompanhada acao) async {
    final uri = Uri.parse(
      'https://query1.finance.yahoo.com/v8/finance/chart/${acao.ticker}.SA?range=1y&interval=1d',
    );
    final resposta = await _cliente.get(
      uri,
      headers: const {'User-Agent': 'Mozilla/5.0'},
    ).timeout(tempoLimite);
    if (resposta.statusCode != 200) {
      throw Exception('Yahoo Finance, ${acao.ticker}: HTTP ${resposta.statusCode}');
    }

    final corpo = jsonDecode(resposta.body) as Map<String, dynamic>;
    final grafico = corpo['chart'] as Map<String, dynamic>? ?? const {};
    final resultados = grafico['result'] as List<dynamic>? ?? const [];
    if (resultados.isEmpty) {
      throw Exception('Yahoo Finance, ${acao.ticker}: sem resultados');
    }

    final dados = resultados.first as Map<String, dynamic>;
    final indicadores = dados['indicators'] as Map<String, dynamic>? ?? const {};
    final precos = _primeiraLista(indicadores['adjclose'], 'adjclose') ??
        _primeiraLista(indicadores['quote'], 'close') ??
        const [];

    final fechamentos = <double>[];
    for (final preco in precos) {
      if (preco is num && preco > 0) {
        fechamentos.add(preco.toDouble());
      }
    }

    return _montarAcao(acao, fechamentos, 'Yahoo Finance');
  }

  List<dynamic>? _primeiraLista(dynamic grupo, String campo) {
    if (grupo is! List || grupo.isEmpty) return null;
    final primeiro = grupo.first;
    if (primeiro is! Map) return null;
    final lista = primeiro[campo];
    return lista is List ? lista : null;
  }

  Investimento _montarAcao(
    _AcaoAcompanhada acao,
    List<double> fechamentos,
    String origem,
  ) {
    final metricas = metricasDoHistorico(fechamentos);

    return Investimento(
      id: acao.ticker.toLowerCase(),
      nome: acao.nome,
      descricao: acao.descricao,
      tipo: TipoInvestimento.acao,
      rentabilidadePct: metricas.rentabilidade12MesesPct,
      risco: RiscoInvestimento.alto,
      chanceDePrejuizoPct: metricas.chanceDePrejuizoPct,
      maiorQuedaPct: metricas.maiorQuedaPct,
      fonte: '$origem: ${fechamentos.length} pregões dos últimos 12 meses',
    );
  }

  double? _precoDoDia(Map<String, dynamic> dia) {
    final ajustado = dia['adjustedClose'];
    if (ajustado is num) return ajustado.toDouble();
    final fechamento = dia['close'];
    if (fechamento is num) return fechamento.toDouble();
    return null;
  }

  num _numero(dynamic valor) => valor is num ? valor : 0;
}
