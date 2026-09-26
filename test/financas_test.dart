import 'package:flutter_test/flutter_test.dart';

import 'package:cp4_hercules/models/gasto.dart';
import 'package:cp4_hercules/services/financas_repository.dart';
import 'package:cp4_hercules/services/mock_financas_repository.dart';

void main() {
  group('MockFinancasRepository', () {
    late MockFinancasRepository repo;

    setUp(() => repo = MockFinancasRepository());

    test('salva e lê o salário', () async {
      expect(await repo.buscarSalario(), 0.0);
      await repo.salvarSalario(2500);
      expect(await repo.buscarSalario(), 2500.0);
    });

    test('adiciona, atualiza e remove gastos', () async {
      final a = await repo.adicionarGasto(nome: 'Gasolina', preco: 100);
      final b = await repo.adicionarGasto(nome: 'Mercado', preco: 250.5);
      expect(a.id, isNot(b.id));

      final lista = await repo.listarGastos();
      expect(lista.map((g) => g.nome), ['Gasolina', 'Mercado']);

      final editado = await repo.atualizarGasto(a.copyWith(preco: 90));
      expect(editado.preco, 90.0);
      expect((await repo.listarGastos()).first.preco, 90.0);

      await repo.removerGasto(b.id!);
      expect((await repo.listarGastos()).map((g) => g.nome), ['Gasolina']);
    });

    test('atualizar um gasto que não existe falha', () {
      expect(
        repo.atualizarGasto(const Gasto(id: '99', nome: 'x', preco: 1)),
        throwsA(isA<FinancasFalha>()),
      );
    });

    test('limpar apaga salário e gastos', () async {
      await repo.salvarSalario(1000);
      await repo.adicionarGasto(nome: 'Café', preco: 8);

      repo.limpar();

      expect(await repo.buscarSalario(), 0.0);
      expect(await repo.listarGastos(), isEmpty);
    });
  });

  group('Gasto.fromMap', () {
    test('lê o preço como número ou como texto', () {
      expect(Gasto.fromMap({'id': 'a', 'nome': 'Café', 'preco': 12.5}).preco, 12.5);
      expect(Gasto.fromMap({'id': 'a', 'nome': 'Café', 'preco': '12.50'}).preco, 12.5);
      expect(Gasto.fromMap({'id': 'a', 'nome': 'Café', 'preco': 10}).preco, 10.0);
    });

    test('guarda o id vindo do banco', () {
      final gasto = Gasto.fromMap({'id': 'uuid-1', 'nome': 'Café', 'preco': 1});
      expect(gasto.id, 'uuid-1');
    });
  });
}
