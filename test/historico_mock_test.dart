import 'package:flutter_test/flutter_test.dart';

import 'package:cp4_hercules/core/utils/gastos_mensais.dart';
import 'package:cp4_hercules/core/utils/salarios_mensais.dart';
import 'package:cp4_hercules/data/historico_mock.dart';
import 'package:cp4_hercules/models/gasto.dart';
import 'package:cp4_hercules/models/salario_mensal.dart';

void main() {
  final setembro29 = DateTime(2026, 9, 29);
  final outubro10 = DateTime(2026, 10, 10);

  group('historico_mock', () {
    test('dados reais começam em setembro de 2026', () {
      expect(ehMesMockado(DateTime(2026, 8)), isTrue);
      expect(ehMesMockado(DateTime(2026, 9)), isFalse);
      expect(ehMesMockado(DateTime(2026, 10)), isFalse);
    });

    test('todo usuário tem R\$ 500 de gasto em agosto', () {
      expect(gastoMockDoMes(DateTime(2026, 8)), 500);
    });

    test('todo usuário tem R\$ 2.000 de patrimônio em junho', () {
      expect(patrimonioMockDoMes(DateTime(2026, 6)), 2000);
    });

    test('de setembro em diante não há valor mockado', () {
      expect(gastoMockDoMes(DateTime(2026, 9)), isNull);
      expect(patrimonioMockDoMes(DateTime(2026, 12)), isNull);
    });
  });

  group('gráfico de gastos com meses mockados', () {
    test('meses antes de setembro usam o valor fixo; setembro usa os gastos reais', () {
      final gastos = [
        Gasto(id: '1', nome: 'Mercado', preco: 120, criadoEm: setembro29),
        Gasto(id: '2', nome: 'Antigo', preco: 999, criadoEm: DateTime(2026, 8, 5)),
      ];

      final totais = totalGastoPorMes(
        gastos,
        quantidadeMeses: 6,
        agora: setembro29,
        valorFixoDoMes: gastoMockDoMes,
      );

      expect(totais.map((t) => t.total), [870, 1040, 760, 910, 500, 120]);
    });

    test('em outubro, setembro passa a mostrar os gastos reais do mês', () {
      final gastos = [
        Gasto(id: '1', nome: 'Mercado', preco: 120, criadoEm: setembro29),
        Gasto(id: '2', nome: 'Farmácia', preco: 45, criadoEm: outubro10),
      ];

      final totais = totalGastoPorMes(
        gastos,
        quantidadeMeses: 3,
        agora: outubro10,
        valorFixoDoMes: gastoMockDoMes,
      );

      expect(totais.map((t) => t.total), [500, 120, 45]);
    });
  });

  group('gráfico de patrimônio com meses mockados', () {
    test('meses antes de setembro usam o valor fixo; setembro usa o salário atual', () {
      final meses = salarioPorMes(
        const [],
        quantidadeMeses: 6,
        agora: setembro29,
        salarioAtual: 2600,
        valorFixoDoMes: patrimonioMockDoMes,
      );

      expect(meses.map((m) => m.valor), [1900, 2000, 2000, 2100, 2100, 2600]);
    });

    test('em outubro, setembro usa o valor salvo no histórico', () {
      final meses = salarioPorMes(
        [SalarioMensal(mes: DateTime(2026, 9), valor: 2600)],
        quantidadeMeses: 3,
        agora: outubro10,
        salarioAtual: 2800,
        valorFixoDoMes: patrimonioMockDoMes,
      );

      expect(meses.map((m) => m.valor), [2100, 2600, 2800]);
    });
  });
}
