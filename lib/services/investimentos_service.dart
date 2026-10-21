import '../models/investimento.dart';

class ResultadoInvestimentos {
  final List<Investimento> opcoes;
  final List<String> fontesComFalha;

  const ResultadoInvestimentos({
    required this.opcoes,
    this.fontesComFalha = const [],
  });
}

abstract class InvestimentosService {
  Future<ResultadoInvestimentos> buscarOpcoes();
}
