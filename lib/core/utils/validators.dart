class Validators {
  Validators._();

  static const int senhaMinima = 6;

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? nome(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Como podemos te chamar?';
    if (texto.length < 2) return 'O nome precisa ter ao menos 2 letras.';
    return null;
  }

  static String? email(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Digite seu e-mail.';
    if (!_emailRegex.hasMatch(texto)) return 'Digite um e-mail válido.';
    return null;
  }

  static String? senha(String? valor) {
    final texto = valor ?? '';
    if (texto.isEmpty) return 'Digite sua senha.';
    if (texto.length < senhaMinima) {
      return 'A senha precisa ter ao menos $senhaMinima caracteres.';
    }
    return null;
  }

  static String? Function(String?) confirmarSenha(String Function() senha) {
    return (String? valor) {
      if (valor == null || valor.isEmpty) return 'Repita a senha.';
      if (valor != senha()) return 'As senhas não são iguais.';
      return null;
    };
  }
}
