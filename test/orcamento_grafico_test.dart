import 'package:flutter_test/flutter_test.dart';

import 'package:cp4_hercules/core/theme/app_colors.dart';
import 'package:cp4_hercules/core/utils/orcamento_grafico.dart';
import 'package:cp4_hercules/models/gasto.dart';

void main() {
  group('calcularOrcamento', () {
    test('sem salário informado devolve vazio', () {
      final resultado = calcularOrcamento(salario: 0, gastos: const []);
      expect(resultado.fatias, isEmpty);
      expect(resultado.orcamentoEstourado, isFalse);
    });

    test('sem gastos, o restante ocupa 100%', () {
      final resultado = calcularOrcamento(salario: 2000, gastos: const []);
      expect(resultado.fatias, hasLength(1));
      expect(resultado.fatias.single.nome, 'Restante');
      expect(resultado.fatias.single.valor, 2000);
      expect(resultado.fatias.single.percentual, closeTo(100, 0.001));
    });

    test('cada gasto vira uma fatia e o restante fecha os 100%', () {
      final resultado = calcularOrcamento(
        salario: 2000,
        gastos: const [
          Gasto(id: '1', nome: 'Aluguel', preco: 500),
          Gasto(id: '2', nome: 'Mercado', preco: 300),
        ],
      );

      expect(resultado.orcamentoEstourado, isFalse);
      expect(resultado.fatias.map((f) => f.nome), [
        'Aluguel',
        'Mercado',
        'Restante',
      ]);
      expect(resultado.fatias[0].percentual, closeTo(25, 0.001));
      expect(resultado.fatias[1].percentual, closeTo(15, 0.001));
      expect(resultado.fatias[2].valor, 1200);
      expect(resultado.fatias[2].percentual, closeTo(60, 0.001));

      final somaPercentuais =
          resultado.fatias.fold<double>(0, (s, f) => s + f.percentual);
      expect(somaPercentuais, closeTo(100, 0.001));
    });

    test('gastos maiores que o salário: sem fatia de restante', () {
      final resultado = calcularOrcamento(
        salario: 1000,
        gastos: const [
          Gasto(id: '1', nome: 'Aluguel', preco: 800),
          Gasto(id: '2', nome: 'Mercado', preco: 400),
        ],
      );

      expect(resultado.orcamentoEstourado, isTrue);
      expect(resultado.excedente, closeTo(200, 0.001));
      expect(resultado.fatias.any((f) => f.nome == 'Restante'), isFalse);

      final somaPercentuais =
          resultado.fatias.fold<double>(0, (s, f) => s + f.percentual);
      expect(somaPercentuais, closeTo(100, 0.001));
    });

    test('a cor de cada fatia repete a paleta quando os gastos são muitos', () {
      final gastos = List.generate(
        AppColors.graficoPaleta.length + 1,
        (i) => Gasto(id: '$i', nome: 'Gasto $i', preco: 10),
      );

      final resultado = calcularOrcamento(salario: 1000, gastos: gastos);

      expect(resultado.fatias.first.cor, AppColors.graficoPaleta[0]);
      expect(
        resultado.fatias[AppColors.graficoPaleta.length].cor,
        AppColors.graficoPaleta[0],
      );
    });
  });
}
