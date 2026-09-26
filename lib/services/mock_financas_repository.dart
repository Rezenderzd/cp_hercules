import '../models/gasto.dart';
import 'financas_repository.dart';

class MockFinancasRepository implements FinancasRepository {
  double _salario = 0.0;
  final List<Gasto> _gastos = [];
  int _proximoId = 1;

  @override
  Future<double> buscarSalario() async => _salario;

  @override
  Future<void> salvarSalario(double valor) async {
    _salario = valor;
  }

  @override
  Future<List<Gasto>> listarGastos() async => List<Gasto>.of(_gastos);

  @override
  Future<Gasto> adicionarGasto({
    required String nome,
    required double preco,
  }) async {
    final gasto = Gasto(id: '${_proximoId++}', nome: nome, preco: preco);
    _gastos.add(gasto);
    return gasto;
  }

  @override
  Future<Gasto> atualizarGasto(Gasto gasto) async {
    final indice = _gastos.indexWhere((g) => g.id == gasto.id);
    if (indice == -1) {
      throw const FinancasFalha('Gasto não encontrado.');
    }
    _gastos[indice] = gasto;
    return gasto;
  }

  @override
  Future<void> removerGasto(String id) async {
    _gastos.removeWhere((g) => g.id == id);
  }

  @override
  void limpar() {
    _salario = 0.0;
    _gastos.clear();
  }
}
