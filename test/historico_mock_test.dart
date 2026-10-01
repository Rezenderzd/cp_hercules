import 'package:flutter_test/flutter_test.dart';

import 'package:cp4_hercules/core/utils/gastos_mensais.dart';
import 'package:cp4_hercules/core/utils/salarios_mensais.dart';
import 'package:cp4_hercules/data/historico_mock.dart';
import 'package:cp4_hercules/models/gasto.dart';
import 'package:cp4_hercules/models/salario_mensal.dart';

void main() {
  final contaCriadaEmSetembro = DateTime(2026, 9, 12);
  final setembro29 = DateTime(2026, 9, 29);
  final outubro10 = DateTime(2026, 10, 10);

  group('historico_mock', () {
    test('meses antes da criação da conta são de exemplo; o mês da criação já é real', () {
      expect(ehMesMockado(DateTime(2026, 8), contaCriadaEmSetembro), isTrue);
      expect(ehMesMockado(DateTime(2026, 9), contaCriadaEmSetembro), isFalse);
      expect(ehMesMockado(DateTime(2026, 10), contaCriadaEmSetembro), isFalse);
    });

    test('todo usuário tem R\$ 500 de gasto em agosto', () {
      expect(gastoMockDoMes(DateTime(2026, 8), contaCriadaEmSetembro), 500);
      expect(gastoMockDoMes(DateTime(2027, 8), DateTime(2027, 12)), 500);
    });

    test('todo usuário tem R\$ 2.000 de patrimônio em junho', () {
      expect(patrimonioMockDoMes(DateTime(2026, 6), contaCriadaEmSetembro), 2000);
    });

    test('a partir do mês da criação da conta não há valor de exemplo', () {
      expect(gastoMockDoMes(DateTime(2026, 9), contaCriadaEmSetembro), isNull);
      expect(patrimonioMockDoMes(DateTime(2026, 12), contaCriadaEmSetembro), isNull);
    });

    test('o corte acompanha cada usuário', () {
      final contaCriadaEmJulho = DateTime(2026, 7, 3);
      expect(gastoMockDoMes(DateTime(2026, 8), contaCriadaEmJulho), isNull);
      expect(gastoMockDoMes(DateTime(2026, 6), contaCriadaEmJulho), 760);
    });
  });

  group('gráfico de gastos com meses de exemplo', () {
    test('antes da criação usa o exemplo; do mês da criação em diante usa os gastos reais', () {
      final gastos = [
        Gasto(id: '1', nome: 'Mercado', preco: 120, criadoEm: setembro29),
      ];

      final totais = totalGastoPorMes(
        gastos,
        quantidadeMeses: 6,
        agora: setembro29,
        valorFixoDoMes: (mes) => gastoMockDoMes(mes, contaCriadaEmSetembro),
      );

      expect(totais.map((t) => t.total), [870, 1040, 760, 910, 500, 120]);
    });

    test('mês da criação sem gastos aparece como zero, não como exemplo', () {
      final totais = totalGastoPorMes(
        const [],
        quantidadeMeses: 2,
        agora: setembro29,
        valorFixoDoMes: (mes) => gastoMockDoMes(mes, contaCriadaEmSetembro),
      );

      expect(totais.map((t) => t.total), [500, 0]);
    });

    test('em outubro, setembro continua com os gastos reais', () {
      final gastos = [
        Gasto(id: '1', nome: 'Mercado', preco: 120, criadoEm: setembro29),
        Gasto(id: '2', nome: 'Farmácia', preco: 45, criadoEm: outubro10),
      ];

      final totais = totalGastoPorMes(
        gastos,
        quantidadeMeses: 3,
        agora: outubro10,
        valorFixoDoMes: (mes) => gastoMockDoMes(mes, contaCriadaEmSetembro),
      );

      expect(totais.map((t) => t.total), [500, 120, 45]);
    });
  });

  group('gráfico de patrimônio com meses de exemplo', () {
    test('antes da criação usa o exemplo; o mês atual usa o salário atual', () {
      final meses = salarioPorMes(
        const [],
        quantidadeMeses: 6,
        agora: setembro29,
        salarioAtual: 2600,
        valorFixoDoMes: (mes) => patrimonioMockDoMes(mes, contaCriadaEmSetembro),
      );

      expect(meses.map((m) => m.valor), [1900, 2000, 2000, 2100, 2100, 2600]);
    });

    test('em outubro, setembro usa o valor salvo no histórico', () {
      final meses = salarioPorMes(
        [SalarioMensal(mes: DateTime(2026, 9), valor: 2600)],
        quantidadeMeses: 3,
        agora: outubro10,
        salarioAtual: 2800,
        valorFixoDoMes: (mes) => patrimonioMockDoMes(mes, contaCriadaEmSetembro),
      );

      expect(meses.map((m) => m.valor), [2100, 2600, 2800]);
    });
  });
}
