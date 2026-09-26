String formatarReais(double valor) {
  final negativo = valor < 0;
  final centavosTotais = (valor.abs() * 100).round();
  final inteiro = centavosTotais ~/ 100;
  final centavos = centavosTotais % 100;

  final inteiroComPontos = inteiro
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');

  final sinal = negativo ? '-' : '';
  return '${sinal}R\$ $inteiroComPontos,${centavos.toString().padLeft(2, '0')}';
}

String formatarPercentual(double valor) {
  return '${valor.toStringAsFixed(2).replaceAll('.', ',')}%';
}

double? lerValor(String texto) {
  var t = texto.trim().replaceAll('R\$', '').replaceAll(' ', '');
  if (t.isEmpty) return null;

  if (t.contains(',') && t.contains('.')) {
    t = t.replaceAll('.', '').replaceAll(',', '.');
  } else {
    t = t.replaceAll(',', '.');
  }
  return double.tryParse(t);
}
