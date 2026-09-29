import '../../models/gasto.dart';

bool mesmoMesEAno(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month;
}

List<Gasto> gastosDoMesAtual(List<Gasto> gastos, [DateTime? agora]) {
  final referencia = agora ?? DateTime.now();
  return gastos.where((g) => mesmoMesEAno(g.criadoEm, referencia)).toList();
}

class TotalMensal {
  final DateTime mes;
  final double total;

  const TotalMensal({required this.mes, required this.total});
}

List<TotalMensal> totalGastoPorMes(
  List<Gasto> gastos, {
  int quantidadeMeses = 6,
  DateTime? agora,
  double? Function(DateTime mes)? valorFixoDoMes,
}) {
  final referencia = agora ?? DateTime.now();

  return [
    for (var indice = quantidadeMeses - 1; indice >= 0; indice--)
      _totalDoMes(
        gastos,
        DateTime(referencia.year, referencia.month - indice),
        valorFixoDoMes,
      ),
  ];
}

TotalMensal _totalDoMes(
  List<Gasto> gastos,
  DateTime mes,
  double? Function(DateTime mes)? valorFixoDoMes,
) {
  final valorFixo = valorFixoDoMes?.call(mes);
  if (valorFixo != null) {
    return TotalMensal(mes: mes, total: valorFixo);
  }

  final total = gastos
      .where((g) => mesmoMesEAno(g.criadoEm, mes))
      .fold<double>(0, (soma, g) => soma + g.preco);
  return TotalMensal(mes: mes, total: total);
}

const _mesesAbreviados = [
  'jan',
  'fev',
  'mar',
  'abr',
  'mai',
  'jun',
  'jul',
  'ago',
  'set',
  'out',
  'nov',
  'dez',
];

const _mesesPorExtenso = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

String rotuloMesAbreviado(DateTime mes) {
  final ano = (mes.year % 100).toString().padLeft(2, '0');
  return '${_mesesAbreviados[mes.month - 1]}/$ano';
}

String rotuloMesPorExtenso(DateTime mes) {
  return '${_mesesPorExtenso[mes.month - 1]} de ${mes.year}';
}
