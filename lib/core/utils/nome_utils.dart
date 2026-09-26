String? primeiroNome(String? nomeCompleto) {
  final texto = nomeCompleto?.trim() ?? '';
  if (texto.isEmpty) return null;

  final primeiro = texto.split(RegExp(r'\s+')).first;
  return primeiro[0].toUpperCase() + primeiro.substring(1).toLowerCase();
}

String? nomeDoEmail(String? email) {
  final texto = email?.trim() ?? '';
  if (texto.isEmpty) return null;

  final antesDoArroba = texto.split('@').first;
  final partes = antesDoArroba
      .split(RegExp(r'[._\-+0-9]'))
      .where((parte) => parte.isNotEmpty);
  if (partes.isEmpty) return null;

  return primeiroNome(partes.first);
}
