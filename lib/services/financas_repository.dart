import '../models/gasto.dart';
import '../models/salario_mensal.dart';

class FinancasFalha implements Exception {
  final String mensagem;

  const FinancasFalha(this.mensagem);

  @override
  String toString() => mensagem;
}

abstract class FinancasRepository {
  Future<double> buscarSalario();

  Future<void> salvarSalario(double valor);

  Future<List<SalarioMensal>> listarHistoricoSalarios();

  Future<List<Gasto>> listarGastos();

  Future<Gasto> adicionarGasto({required String nome, required double preco});

  Future<Gasto> atualizarGasto(Gasto gasto);

  Future<void> removerGasto(String id);

  void limpar();
}
