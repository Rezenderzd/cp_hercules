import 'package:flutter_test/flutter_test.dart';

import 'package:cp4_hercules/core/utils/calculos_investimentos.dart';

void main() {
  group('rentabilidadePoupancaAnual', () {
    test('Selic acima de 8,5%: 0,5% ao mês + TR', () {
      expect(
        rentabilidadePoupancaAnual(selicAnual: 15, trMensal: 0.17),
        closeTo(8.342992, 0.0001),
      );
    });

    test('com TR zero, rende os conhecidos 6,17% ao ano', () {
      expect(
        rentabilidadePoupancaAnual(selicAnual: 15, trMensal: 0),
        closeTo(6.167781, 0.0001),
      );
    });

    test('Selic até 8,5%: 70% da Selic + TR', () {
      expect(
        rentabilidadePoupancaAnual(selicAnual: 8, trMensal: 0.17),
        closeTo(7.764554, 0.0001),
      );
    });
  });

  group('metricasDoHistorico', () {
    test('calcula rentabilidade, chance de prejuízo e maior queda', () {
      final m = metricasDoHistorico([10, 12, 8, 11]);

      expect(m.rentabilidade12MesesPct, closeTo(10, 0.0001));
      expect(m.chanceDePrejuizoPct, closeTo(25, 0.0001));
      expect(m.maiorQuedaPct, closeTo(33.3333, 0.001));
    });

    test('ação que só subiu: nenhum dia no prejuízo e nenhuma queda', () {
      final m = metricasDoHistorico([10, 11, 12, 13]);

      expect(m.rentabilidade12MesesPct, closeTo(30, 0.0001));
      expect(m.chanceDePrejuizoPct, 0);
      expect(m.maiorQuedaPct, 0);
    });

    test('ação que só caiu: rentabilidade negativa', () {
      final m = metricasDoHistorico([20, 15, 10]);

      expect(m.rentabilidade12MesesPct, closeTo(-50, 0.0001));
      expect(m.chanceDePrejuizoPct, closeTo(66.6667, 0.001));
      expect(m.maiorQuedaPct, closeTo(50, 0.0001));
    });

    test('exige pelo menos 2 preços', () {
      expect(() => metricasDoHistorico([10]), throwsArgumentError);
    });
  });
}
