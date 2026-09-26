class Gasto {
  final String? id;
  final String nome;
  final double preco;

  const Gasto({this.id, required this.nome, required this.preco});

  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map['id']?.toString(),
      nome: (map['nome'] ?? '').toString(),
      preco: double.tryParse('${map['preco']}') ?? 0.0,
    );
  }

  Gasto copyWith({String? id, String? nome, double? preco}) {
    return Gasto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
    );
  }
}
