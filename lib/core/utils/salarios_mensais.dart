import '../../models/salario_mensal.dart';

List<SalarioMensal> salarioPorMes(
  List<SalarioMensal> historico, {
  int quantidadeMeses = 6,
  DateTime? agora,
  double? salarioAtual,
  double? Function(DateTime mes)? valorFixoDoMes,
}) {
  final referencia = agora ?? DateTime.now();
  final porMes = <String, double>{
    for (final entrada in historico) _chave(entrada.mes): entrada.valor,
  };

  double ultimoConhecido = 0;
  final resultado = <SalarioMensal>[];

  for (var indice = quantidadeMeses - 1; indice >= 0; indice--) {
    final mes = DateTime(referencia.year, referencia.month - indice);
    final ehMesAtual = indice == 0;

    final valorFixo = valorFixoDoMes?.call(mes);

    if (valorFixo != null) {
      ultimoConhecido = valorFixo;
    } else if (ehMesAtual && salarioAtual != null) {
      ultimoConhecido = salarioAtual;
    } else {
      final valorDoMes = porMes[_chave(mes)];
      if (valorDoMes != null) {
        ultimoConhecido = valorDoMes;
      }
    }

    resultado.add(SalarioMensal(mes: mes, valor: ultimoConhecido));
  }

  return resultado;
}

String _chave(DateTime mes) => '${mes.year}-${mes.month}';
