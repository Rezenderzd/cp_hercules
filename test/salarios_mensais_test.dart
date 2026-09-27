import 'package:flutter_test/flutter_test.dart';

import 'package:cp4_hercules/core/utils/salarios_mensais.dart';
import 'package:cp4_hercules/models/salario_mensal.dart';

void main() {
  group('salarioPorMes', () {
    test('sem nenhum histórico, todos os meses ficam em zero', () {
      final meses = salarioPorMes(
        const [],
        quantidadeMeses: 3,
        agora: DateTime(2026, 9, 26),
      );

      expect(meses, hasLength(3));
      expect(meses.every((m) => m.valor == 0), isTrue);
    });

    test('um valor definido em um mês vale também para os meses seguintes', () {
      final meses = salarioPorMes(
        [SalarioMensal(mes: DateTime(2026, 7), valor: 2000)],
        quantidadeMeses: 3,
        agora: DateTime(2026, 9, 26),
      );

      expect(meses.map((m) => m.valor), [2000, 2000, 2000]);
    });

    test('um aumento no mês atual não altera os meses anteriores', () {
      final historico = [
        SalarioMensal(mes: DateTime(2026, 7), valor: 2000),
        SalarioMensal(mes: DateTime(2026, 9), valor: 2500),
      ];

      final meses = salarioPorMes(
        historico,
        quantidadeMeses: 3,
        agora: DateTime(2026, 9, 26),
      );

      expect(meses[0].valor, 2000);
      expect(meses[1].valor, 2000);
      expect(meses[2].valor, 2500);
    });

    test('salvar de novo no mesmo mês substitui o valor daquele mês', () {
      final historico = [
        SalarioMensal(mes: DateTime(2026, 9), valor: 2000),
        SalarioMensal(mes: DateTime(2026, 9), valor: 2200),
      ];

      final meses = salarioPorMes(
        historico,
        quantidadeMeses: 1,
        agora: DateTime(2026, 9, 26),
      );

      expect(meses.single.valor, 2200);
    });

    test('uma queda de salário aparece corretamente no mês seguinte', () {
      final historico = [
        SalarioMensal(mes: DateTime(2026, 8), valor: 3000),
        SalarioMensal(mes: DateTime(2026, 9), valor: 2200),
      ];

      final meses = salarioPorMes(
        historico,
        quantidadeMeses: 2,
        agora: DateTime(2026, 9, 26),
      );

      expect(meses[0].valor, 3000);
      expect(meses[1].valor, 2200);
      expect(meses[1].valor - meses[0].valor, -800);
    });

    test('o mês atual usa o salário atual, mesmo sem histórico salvo', () {
      final meses = salarioPorMes(
        const [],
        quantidadeMeses: 3,
        agora: DateTime(2026, 9, 26),
        salarioAtual: 2800,
      );

      expect(meses.map((m) => m.valor), [0, 0, 2800]);
    });

    test('o salário atual substitui só o mês atual; os anteriores ficam fixos', () {
      final historico = [
        SalarioMensal(mes: DateTime(2026, 8), valor: 2000),
        SalarioMensal(mes: DateTime(2026, 9), valor: 2100),
      ];

      final meses = salarioPorMes(
        historico,
        quantidadeMeses: 3,
        agora: DateTime(2026, 10, 1),
        salarioAtual: 2600,
      );

      expect(meses[0].valor, 2000);
      expect(meses[1].valor, 2100);
      expect(meses[2].valor, 2600);
    });

    test('atravessa a virada do ano corretamente', () {
      final historico = [
        SalarioMensal(mes: DateTime(2025, 12), valor: 1800),
        SalarioMensal(mes: DateTime(2026, 1), valor: 2000),
      ];

      final meses = salarioPorMes(
        historico,
        quantidadeMeses: 2,
        agora: DateTime(2026, 1, 15),
      );

      expect(meses[0].valor, 1800);
      expect(meses[1].valor, 2000);
    });
  });
}
