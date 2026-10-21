enum RiscoInvestimento {
  baixo('Risco baixo'),
  medio('Risco médio'),
  alto('Risco alto');

  const RiscoInvestimento(this.rotulo);

  final String rotulo;
}

enum TipoInvestimento { rendaFixa, acao }

class Investimento {
  final String id;
  final String nome;
  final String descricao;
  final TipoInvestimento tipo;
  final double rentabilidadePct;
  final RiscoInvestimento risco;
  final double chanceDePrejuizoPct;
  final double maiorQuedaPct;
  final String? garantia;
  final String fonte;

  const Investimento({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tipo,
    required this.rentabilidadePct,
    required this.risco,
    required this.chanceDePrejuizoPct,
    required this.maiorQuedaPct,
    required this.fonte,
    this.garantia,
  });

  double retornoEm12Meses(double valor) => valor * rentabilidadePct / 100;

  double totalEm12Meses(double valor) => valor + retornoEm12Meses(valor);

  double perdaNaMaiorQueda(double valor) => valor * maiorQuedaPct / 100;
}
