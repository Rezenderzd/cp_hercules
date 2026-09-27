class Gasto {
  final String? id;
  final String nome;
  final double preco;
  final DateTime criadoEm;

  Gasto({
    this.id,
    required this.nome,
    required this.preco,
    DateTime? criadoEm,
  }) : criadoEm = criadoEm ?? DateTime.now();

  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map['id']?.toString(),
      nome: (map['nome'] ?? '').toString(),
      preco: double.tryParse('${map['preco']}') ?? 0.0,
      criadoEm: DateTime.tryParse('${map['created_at']}'),
    );
  }

  Gasto copyWith({
    String? id,
    String? nome,
    double? preco,
    DateTime? criadoEm,
  }) {
    return Gasto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}
