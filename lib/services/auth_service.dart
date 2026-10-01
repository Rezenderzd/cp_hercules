class AuthFalha implements Exception {
  final String mensagem;

  const AuthFalha(this.mensagem);

  @override
  String toString() => mensagem;
}

abstract class AuthService {
  bool get estaLogado;

  String? get nomeUsuario;

  DateTime? get contaCriadaEm;

  Future<void> entrar({required String email, required String senha});

  Future<void> criarConta({
    required String nome,
    required String email,
    required String senha,
  });

  Future<void> sair();
}
