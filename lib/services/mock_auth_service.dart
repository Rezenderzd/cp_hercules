import '../core/utils/nome_utils.dart';
import 'auth_service.dart';

class MockAuthService implements AuthService {
  MockAuthService({this.latencia = const Duration(milliseconds: 800)});

  final Duration latencia;
  bool _logado = false;
  DateTime? _contaCriadaEm;
  String? _nome;

  @override
  bool get estaLogado => _logado;

  @override
  String? get nomeUsuario => _nome;

  @override
  DateTime? get contaCriadaEm => _contaCriadaEm;

  @override
  Future<void> entrar({required String email, required String senha}) async {
    await Future<void>.delayed(latencia);
    _logado = true;
    _nome = nomeDoEmail(email);
    _contaCriadaEm ??= DateTime.now();
  }

  @override
  Future<void> criarConta({
    required String nome,
    required String email,
    required String senha,
  }) async {
    await Future<void>.delayed(latencia);
    _logado = true;
    _nome = nome.trim().isNotEmpty ? nome.trim() : nomeDoEmail(email);
    _contaCriadaEm = DateTime.now();
  }

  @override
  Future<void> sair() async {
    _logado = false;
    _nome = null;
    _contaCriadaEm = null;
  }
}
