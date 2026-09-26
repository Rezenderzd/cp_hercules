enum RiscoInvestimento {
  baixo('Risco baixo'),
  medio('Risco médio'),
  alto('Risco alto');

  const RiscoInvestimento(this.rotulo);

  final String rotulo;
}

class Investimento {
  final String id;
  final String nome;
  final String descricao;

  final double rentabilidadeAnual;

  final RiscoInvestimento risco;

  final int chanceDeErroPct;

  final int perdaSeErrarPct;

  const Investimento({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.rentabilidadeAnual,
    required this.risco,
    required this.chanceDeErroPct,
    required this.perdaSeErrarPct,
  });

  double retornoEm12Meses(double valor) => valor * rentabilidadeAnual / 100;

  double totalEm12Meses(double valor) => valor + retornoEm12Meses(valor);

  double perdaMaxima(double valor) => valor * perdaSeErrarPct / 100;
}
