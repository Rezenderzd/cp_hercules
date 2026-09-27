import 'package:flutter_test/flutter_test.dart';

import 'package:cp4_hercules/core/utils/gastos_mensais.dart';
import 'package:cp4_hercules/models/gasto.dart';

void main() {
  final setembro15 = DateTime(2026, 9, 15);
  final setembro28 = DateTime(2026, 9, 28);
  final outubro1 = DateTime(2026, 10, 1);
  final agosto10 = DateTime(2026, 8, 10);

  group('mesmoMesEAno', () {
    test('true para datas no mesmo mês e ano', () {
      expect(mesmoMesEAno(setembro15, setembro28), isTrue);
    });

    test('false para meses diferentes', () {
      expect(mesmoMesEAno(setembro28, outubro1), isFalse);
    });

    test('false para o mesmo mês em anos diferentes', () {
      expect(mesmoMesEAno(setembro15, DateTime(2025, 9, 15)), isFalse);
    });
  });

  group('gastosDoMesAtual', () {
    test('mantém só os gastos do mês de referência', () {
      final gastos = [
        Gasto(id: '1', nome: 'Mercado', preco: 100, criadoEm: setembro15),
        Gasto(id: '2', nome: 'Farmácia', preco: 50, criadoEm: setembro28),
        Gasto(id: '3', nome: 'Aluguel', preco: 900, criadoEm: agosto10),
      ];

      final resultado = gastosDoMesAtual(gastos, setembro28);

      expect(resultado.map((g) => g.id), ['1', '2']);
    });

    test('no dia 1º do mês seguinte, os gastos do mês anterior somem da lista atual', () {
      final gastos = [
        Gasto(id: '1', nome: 'Mercado', preco: 100, criadoEm: setembro28),
      ];

      expect(gastosDoMesAtual(gastos, outubro1), isEmpty);
    });
  });

  group('totalGastoPorMes', () {
    test('soma os gastos de cada mês e devolve 0 para os meses sem gasto', () {
      final gastos = [
        Gasto(id: '1', nome: 'Mercado', preco: 100, criadoEm: agosto10),
        Gasto(id: '2', nome: 'Aluguel', preco: 900, criadoEm: setembro15),
        Gasto(id: '3', nome: 'Farmácia', preco: 50, criadoEm: setembro28),
      ];

      final totais = totalGastoPorMes(gastos, quantidadeMeses: 3, agora: setembro28);

      expect(totais.map((t) => '${t.mes.month}/${t.mes.year}'), [
        '7/2026',
        '8/2026',
        '9/2026',
      ]);
      expect(totais[0].total, 0);
      expect(totais[1].total, 100);
      expect(totais[2].total, 950);
    });

    test('um gasto novo entra no mês atual e não altera os meses fechados', () {
      final antesDoNovoGasto = totalGastoPorMes(
        [Gasto(id: '1', nome: 'Aluguel', preco: 900, criadoEm: setembro15)],
        quantidadeMeses: 2,
        agora: setembro28,
      );

      final depoisDoNovoGasto = totalGastoPorMes(
        [
          Gasto(id: '1', nome: 'Aluguel', preco: 900, criadoEm: setembro15),
          Gasto(id: '2', nome: 'Mercado', preco: 80, criadoEm: outubro1),
        ],
        quantidadeMeses: 2,
        agora: outubro1,
      );

      expect(antesDoNovoGasto[1].total, 900);
      expect(depoisDoNovoGasto[0].total, 900);
      expect(depoisDoNovoGasto[1].total, 80);
    });

    test('a virada do mês soma corretamente atravessando o ano', () {
      final gastos = [
        Gasto(id: '1', nome: 'Ceia', preco: 300, criadoEm: DateTime(2025, 12, 20)),
        Gasto(id: '2', nome: 'Ano novo', preco: 150, criadoEm: DateTime(2026, 1, 2)),
      ];

      final totais = totalGastoPorMes(
        gastos,
        quantidadeMeses: 2,
        agora: DateTime(2026, 1, 15),
      );

      expect(totais[0].total, 300);
      expect(totais[1].total, 150);
    });
  });

  group('rótulos de mês', () {
    test('rotuloMesAbreviado usa 3 letras e 2 dígitos de ano', () {
      expect(rotuloMesAbreviado(DateTime(2026, 9, 1)), 'set/26');
      expect(rotuloMesAbreviado(DateTime(2026, 1, 1)), 'jan/26');
    });

    test('rotuloMesPorExtenso escreve o nome completo do mês', () {
      expect(rotuloMesPorExtenso(DateTime(2026, 9, 1)), 'setembro de 2026');
      expect(rotuloMesPorExtenso(DateTime(2026, 3, 1)), 'março de 2026');
    });
  });
}
