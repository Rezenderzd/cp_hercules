import 'dart:math' as math;

double rentabilidadePoupancaAnual({
  required double selicAnual,
  required double trMensal,
}) {
  final double jurosMensais;
  if (selicAnual > 8.5) {
    jurosMensais = 0.005;
  } else {
    jurosMensais = math.pow(1 + 0.7 * selicAnual / 100, 1 / 12) - 1;
  }

  final rendimentoMensal = jurosMensais + trMensal / 100;
  return (math.pow(1 + rendimentoMensal, 12) - 1) * 100;
}

class MetricasAcao {
  final double rentabilidade12MesesPct;
  final double chanceDePrejuizoPct;
  final double maiorQuedaPct;

  const MetricasAcao({
    required this.rentabilidade12MesesPct,
    required this.chanceDePrejuizoPct,
    required this.maiorQuedaPct,
  });
}

MetricasAcao metricasDoHistorico(List<double> fechamentos) {
  if (fechamentos.length < 2) {
    throw ArgumentError('São necessários pelo menos 2 preços de fechamento.');
  }

  final primeiro = fechamentos.first;
  final ultimo = fechamentos.last;

  final diasComPrejuizo = fechamentos.where((preco) => preco > ultimo).length;

  var pico = fechamentos.first;
  var maiorQueda = 0.0;
  for (final preco in fechamentos) {
    if (preco > pico) pico = preco;
    final queda = (pico - preco) / pico;
    if (queda > maiorQueda) maiorQueda = queda;
  }

  return MetricasAcao(
    rentabilidade12MesesPct: (ultimo / primeiro - 1) * 100,
    chanceDePrejuizoPct: diasComPrejuizo / fechamentos.length * 100,
    maiorQuedaPct: maiorQueda * 100,
  );
}
