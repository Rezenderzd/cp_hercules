import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cp4_hercules/core/theme/app_theme.dart';
import 'package:cp4_hercules/core/utils/moeda.dart';
import 'package:cp4_hercules/models/investimento.dart';
import 'package:cp4_hercules/screens/investimentos/investimentos_screen.dart';

import 'fake_investimentos_service.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('formatação e leitura de valores', () {
    test('formatarReais usa o padrão brasileiro', () {
      expect(formatarReais(1050), 'R\$ 1.050,00');
      expect(formatarReais(0.5), 'R\$ 0,50');
      expect(formatarReais(525), 'R\$ 525,00');
      expect(formatarReais(1234567.891), 'R\$ 1.234.567,89');
      expect(formatarReais(-25), '-R\$ 25,00');
    });

    test('formatarPercentual usa vírgula', () {
      expect(formatarPercentual(10.5), '10,50%');
      expect(formatarPercentual(19), '19,00%');
    });

    test('lerValor aceita os formatos que o usuário digita', () {
      expect(lerValor('5000'), 5000);
      expect(lerValor('5000,50'), 5000.5);
      expect(lerValor('5.000,50'), 5000.5);
      expect(lerValor('1500.50'), 1500.5);
      expect(lerValor('R\$ 200'), 200);
    });

    test('lerValor devolve null quando não é número', () {
      expect(lerValor(''), isNull);
      expect(lerValor('   '), isNull);
      expect(lerValor('abc'), isNull);
    });
  });

  group('Investimento', () {
    test('calcula retorno, total e perda na maior queda', () {
      final itau = investimentosDeTeste[3];
      expect(itau.retornoEm12Meses(5000), closeTo(950, 0.001));
      expect(itau.totalEm12Meses(5000), closeTo(5950, 0.001));
      expect(itau.perdaNaMaiorQueda(5000), closeTo(1250, 0.001));
    });

    test('rentabilidade negativa gera retorno negativo', () {
      final bradesco = investimentosDeTeste[4];
      expect(bradesco.retornoEm12Meses(5000), closeTo(-1600, 0.001));
      expect(bradesco.totalEm12Meses(5000), closeTo(3400, 0.001));
    });

    test('renda fixa não tem chance de prejuízo nem queda', () {
      for (final i in investimentosDeTeste.where((i) => i.tipo == TipoInvestimento.rendaFixa)) {
        expect(i.chanceDePrejuizoPct, 0, reason: i.nome);
        expect(i.maiorQuedaPct, 0, reason: i.nome);
        expect(i.garantia, isNotNull, reason: i.nome);
      }
    });
  });

  group('InvestimentosScreen', () {
    void usarTelaGrande(WidgetTester tester) {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    Future<FakeInvestimentosService> abrirTela(
      WidgetTester tester, {
      FakeInvestimentosService? servico,
    }) async {
      usarTelaGrande(tester);
      final fake = servico ?? FakeInvestimentosService();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(body: InvestimentosScreen(service: fake)),
        ),
      );
      await tester.pumpAndSettle();
      return fake;
    }

    Future<void> simular(WidgetTester tester, String valor) async {
      await tester.enterText(find.byType(TextField), valor);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Simular'));
      await tester.pumpAndSettle();
    }

    testWidgets('mostra as opções reais com risco, garantia e fonte',
        (WidgetTester tester) async {
      await abrirTela(tester);

      expect(find.text('Risco baixo'), findsNWidgets(3));
      expect(find.text('Risco alto'), findsNWidgets(2));
      expect(find.text('Risco médio'), findsNothing);
      expect(find.text('Garantido pelo Tesouro Nacional.'), findsOneWidget);
      expect(find.text('Fonte: Banco Central: meta da Selic de 16/09/2026'), findsOneWidget);
      expect(find.text('Dias do último ano com prejuízo hoje: 85,00%'), findsOneWidget);
      expect(find.text('Exemplo com R\$ 1.000,00'), findsNWidgets(5));
      expect(find.text('+ R\$ 105,00'), findsOneWidget);
      expect(find.text('- R\$ 320,00'), findsOneWidget);
    });

    testWidgets('simula o retorno em R\$, inclusive negativo',
        (WidgetTester tester) async {
      await abrirTela(tester);
      await simular(tester, '5000');

      expect(find.text('Simulação para R\$ 5.000,00 em 12 meses'), findsOneWidget);
      expect(find.text('Exemplo com R\$ 1.000,00'), findsNothing);
      expect(find.text('+ R\$ 525,00'), findsOneWidget);
      expect(find.text('Total: R\$ 5.525,00'), findsOneWidget);
      expect(find.text('- R\$ 1.600,00'), findsOneWidget);
      expect(find.text('Total: R\$ 3.400,00'), findsOneWidget);
      expect(
        find.text('Maior queda nos últimos 12 meses: 48,00% (R\$ 2.400,00 sobre o valor simulado)'),
        findsOneWidget,
      );
    });

    testWidgets('lista do menor para o maior risco', (WidgetTester tester) async {
      await abrirTela(tester);

      double topo(String nome) => tester.getTopLeft(find.text(nome)).dy;

      expect(topo('Poupança'), lessThan(topo('Tesouro Selic')));
      expect(topo('Tesouro Selic'), lessThan(topo('CDB 100% do CDI')));
      expect(topo('CDB 100% do CDI'), lessThan(topo('Bradesco (BBDC4)')));
      expect(topo('Bradesco (BBDC4)'), lessThan(topo('Itaú Unibanco (ITUB4)')));
    });

    testWidgets('avisa quando uma fonte falha e permite tentar de novo',
        (WidgetTester tester) async {
      final fake = FakeInvestimentosService(
        opcoes: investimentosDeTeste.take(3).toList(),
        fontesComFalha: ['Cotação do Itaú (brapi.dev)', 'Cotações do Bradesco e da Vivo (Yahoo Finance)'],
      );
      await abrirTela(tester, servico: fake);

      expect(find.textContaining('Não foi possível carregar: Cotação do Itaú (brapi.dev) e Cotações do Bradesco'), findsOneWidget);
      expect(find.text('Risco baixo'), findsNWidgets(3));
      expect(find.text('Risco alto'), findsNothing);

      fake
        ..opcoes = investimentosDeTeste
        ..fontesComFalha = [];
      await tester.tap(find.text('Tentar de novo'));
      await tester.pumpAndSettle();

      expect(fake.chamadas, 2);
      expect(find.textContaining('Não foi possível carregar'), findsNothing);
      expect(find.text('Risco alto'), findsNWidgets(2));
    });

    testWidgets('limpa o campo depois de simular e mantém o valor no resumo',
        (WidgetTester tester) async {
      await abrirTela(tester);
      await simular(tester, '5000');

      final campo = tester.widget<TextField>(find.byType(TextField));
      expect(campo.controller?.text, isEmpty);
      expect(find.text('Simulação para R\$ 5.000,00 em 12 meses'), findsOneWidget);
    });

    testWidgets('não limpa o campo quando o valor é inválido',
        (WidgetTester tester) async {
      await abrirTela(tester);
      await simular(tester, '0');

      final campo = tester.widget<TextField>(find.byType(TextField));
      expect(campo.controller?.text, '0');
      expect(find.text('Digite um valor maior que zero.'), findsOneWidget);
    });

    testWidgets('aceita valor no formato 5.000,50', (WidgetTester tester) async {
      await abrirTela(tester);
      await simular(tester, '5.000,50');

      expect(find.text('Simulação para R\$ 5.000,50 em 12 meses'), findsOneWidget);
    });
  });
}
