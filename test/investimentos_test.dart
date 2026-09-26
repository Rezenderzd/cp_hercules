import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cp4_hercules/core/theme/app_theme.dart';
import 'package:cp4_hercules/core/utils/moeda.dart';
import 'package:cp4_hercules/data/investimentos_mock.dart';
import 'package:cp4_hercules/models/investimento.dart';
import 'package:cp4_hercules/screens/investimentos/investimentos_screen.dart';

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
    const tesouro = Investimento(
      id: 't',
      nome: 'Tesouro',
      descricao: '',
      rentabilidadeAnual: 10.5,
      risco: RiscoInvestimento.baixo,
      chanceDeErroPct: 2,
      perdaSeErrarPct: 5,
    );

    test('calcula retorno, total e perda máxima para R\$ 5.000', () {
      expect(tesouro.retornoEm12Meses(5000), closeTo(525, 0.001));
      expect(tesouro.totalEm12Meses(5000), closeTo(5525, 0.001));
      expect(tesouro.perdaMaxima(5000), closeTo(250, 0.001));
    });

    test('valor zero não rende nem perde', () {
      expect(tesouro.retornoEm12Meses(0), 0);
      expect(tesouro.perdaMaxima(0), 0);
    });
  });

  group('dados mockados: mais risco = mais retorno e mais chance de erro', () {
    Iterable<Investimento> grupo(RiscoInvestimento r) =>
        investimentosMock.where((i) => i.risco == r);

    double menor(Iterable<Investimento> l, double Function(Investimento) f) =>
        l.map(f).reduce((a, b) => a < b ? a : b);

    double maior(Iterable<Investimento> l, double Function(Investimento) f) =>
        l.map(f).reduce((a, b) => a > b ? a : b);

    final criterios = <String, double Function(Investimento)>{
      'rentabilidade': (i) => i.rentabilidadeAnual,
      'chance de dar errado': (i) => i.chanceDeErroPct.toDouble(),
      'perda se der errado': (i) => i.perdaSeErrarPct.toDouble(),
    };

    test('existe ao menos uma opção de cada risco', () {
      for (final risco in RiscoInvestimento.values) {
        expect(grupo(risco), isNotEmpty, reason: risco.rotulo);
      }
    });

    for (final entrada in criterios.entries) {
      test('${entrada.key}: baixo < médio < alto', () {
        final f = entrada.value;
        final baixo = grupo(RiscoInvestimento.baixo);
        final medio = grupo(RiscoInvestimento.medio);
        final alto = grupo(RiscoInvestimento.alto);

        expect(maior(baixo, f), lessThan(menor(medio, f)));
        expect(maior(medio, f), lessThan(menor(alto, f)));
      });
    }

    test('percentuais ficam entre 0 e 100', () {
      for (final i in investimentosMock) {
        expect(i.chanceDeErroPct, inInclusiveRange(0, 100), reason: i.nome);
        expect(i.perdaSeErrarPct, inInclusiveRange(0, 100), reason: i.nome);
      }
    });
  });

  group('InvestimentosScreen', () {
    void usarTelaGrande(WidgetTester tester) {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    Future<void> abrirTela(WidgetTester tester) async {
      usarTelaGrande(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: InvestimentosScreen()),
        ),
      );
    }

    Future<void> simular(WidgetTester tester, String valor) async {
      await tester.enterText(find.byType(TextField), valor);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Simular'));
      await tester.pumpAndSettle();
    }

    testWidgets('mostra todas as opções com risco e chance, sem valores em R\$',
        (WidgetTester tester) async {
      await abrirTela(tester);

      expect(find.text('Risco baixo'), findsNWidgets(3));
      expect(find.text('Risco médio'), findsNWidgets(2));
      expect(find.text('Risco alto'), findsNWidgets(2));
      expect(find.text('Chance de dar errado: 45%'), findsOneWidget);
      expect(
        find.text('Informe um valor para ver quanto cada opção pode render.'),
        findsOneWidget,
      );
      expect(find.textContaining('+ R\$'), findsNothing);
    });

    testWidgets('simula o retorno em R\$ para o valor informado',
        (WidgetTester tester) async {
      await abrirTela(tester);
      await simular(tester, '5000');

      expect(find.text('Simulação para R\$ 5.000,00 em 12 meses'), findsOneWidget);

      expect(find.text('+ R\$ 525,00'), findsOneWidget);
      expect(find.text('Total: R\$ 5.525,00'), findsOneWidget);

      expect(find.text('+ R\$ 1.600,00'), findsOneWidget);
      expect(
        find.text('Se der errado: perda de até R\$ 3.500,00 (70%)'),
        findsOneWidget,
      );
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

    testWidgets('avisa quando o valor está vazio ou é zero',
        (WidgetTester tester) async {
      await abrirTela(tester);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Simular'));
      await tester.pump();
      expect(find.text('Digite um valor maior que zero.'), findsOneWidget);

      await simular(tester, '0');
      expect(find.text('Digite um valor maior que zero.'), findsOneWidget);
      expect(find.textContaining('+ R\$'), findsNothing);
    });

    testWidgets('lista do menor para o maior risco', (WidgetTester tester) async {
      await abrirTela(tester);

      double topo(String nome) => tester.getTopLeft(find.text(nome)).dy;

      expect(topo('Poupança'), lessThan(topo('Fundos imobiliários')));
      expect(topo('Fundos imobiliários'), lessThan(topo('Ações')));
      expect(topo('Ações'), lessThan(topo('Criptomoedas')));
    });
  });
}
