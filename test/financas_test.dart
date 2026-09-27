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

    test('salva o salário e registra no histórico do mês atual', () async {
      await repo.salvarSalario(2000);
      await repo.salvarSalario(2200);

      final historico = await repo.listarHistoricoSalarios();
      final agora = DateTime.now();

      expect(historico, hasLength(1));
      expect(historico.single.valor, 2200);
      expect(historico.single.mes.year, agora.year);
      expect(historico.single.mes.month, agora.month);
    });

    test('limpar apaga também o histórico de salário', () async {
      await repo.salvarSalario(1000);
      repo.limpar();

      expect(await repo.listarHistoricoSalarios(), isEmpty);
    });

    test('atualizar um gasto que não existe falha', () {
      expect(
        repo.atualizarGasto(Gasto(id: '99', nome: 'x', preco: 1)),
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

    test('lê a data de criação enviada pelo Supabase', () {
      final gasto = Gasto.fromMap({
        'id': 'uuid-1',
        'nome': 'Café',
        'preco': 1,
        'created_at': '2026-09-15T10:00:00+00:00',
      });
      expect(gasto.criadoEm, DateTime.parse('2026-09-15T10:00:00+00:00'));
    });

    test('sem created_at, usa a hora atual em vez de quebrar', () {
      final antes = DateTime.now();
      final gasto = Gasto.fromMap({'id': 'a', 'nome': 'Café', 'preco': 1});
      expect(gasto.criadoEm.isAfter(antes.subtract(const Duration(seconds: 5))), isTrue);
    });
  });
}
