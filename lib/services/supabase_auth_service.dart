import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/nome_utils.dart';
import 'auth_service.dart';

class SupabaseAuthService implements AuthService {
  SupabaseAuthService(this._client);

  final SupabaseClient _client;

  @override
  bool get estaLogado => _client.auth.currentSession != null;

  @override
  String? get nomeUsuario {
    final usuario = _client.auth.currentUser;
    if (usuario == null) return null;

    final nome = usuario.userMetadata?['nome'];
    if (nome is String && nome.trim().isNotEmpty) return nome;

    return nomeDoEmail(usuario.email);
  }

  @override
  Future<void> entrar({required String email, required String senha}) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: senha);
    } on AuthException catch (e) {
      throw AuthFalha(_traduzir(e));
    } catch (_) {
      throw const AuthFalha(_semConexao);
    }
  }

  @override
  Future<void> criarConta({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final resposta = await _client.auth.signUp(
        email: email,
        password: senha,
        data: {'nome': nome},
      );
      if (resposta.session == null) {
        throw const AuthFalha(
          'A conta foi criada, mas o Supabase pediu confirmação por e-mail. '
          'Desative "Confirm email" em Authentication > Providers > Email no painel do Supabase.',
        );
      }
    } on AuthFalha {
      rethrow;
    } on AuthException catch (e) {
      throw AuthFalha(_traduzir(e));
    } catch (_) {
      throw const AuthFalha(_semConexao);
    }
  }

  @override
  Future<void> sair() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw AuthFalha(_traduzir(e));
    } catch (_) {
      throw const AuthFalha(_semConexao);
    }
  }

  static const String _semConexao =
      'Não foi possível conectar. Verifique sua internet e tente de novo.';

  String _traduzir(AuthException e) {
    debugPrint(
      'Zena+ Supabase auth código=${e.code} status=${e.statusCode} mensagem=${e.message}',
    );
    final msg = e.message.toLowerCase();

    if (msg.contains('invalid login credentials')) {
      return 'E-mail ou senha incorretos.';
    }
    if (msg.contains('email not confirmed')) {
      return 'Confirme seu e-mail antes de entrar. Enviamos um link para a sua caixa de entrada.';
    }
    if (msg.contains('already registered') ||
        msg.contains('already been registered')) {
      return 'Já existe uma conta com esse e-mail. Tente entrar.';
    }
    if (msg.contains('password should be at least')) {
      return 'A senha precisa ter ao menos 6 caracteres.';
    }
    if (msg.contains('rate limit') || msg.contains('too many')) {
      return 'Muitas tentativas. Aguarde um pouco e tente de novo.';
    }
    if (msg.contains('invalid format') || msg.contains('validate email')) {
      return 'Digite um e-mail válido.';
    }
    if (msg.contains('database error')) {
      return 'Não foi possível salvar a conta no banco. Confira se as tabelas '
          'e o trigger do zena_supabase_setup.sql foram criados no Supabase.';
    }
    if (msg.contains('signups not allowed') || msg.contains('signup_disabled')) {
      return 'O cadastro está desativado no Supabase. Ative em Authentication > Providers > Email.';
    }
    return 'Não foi possível concluir. Tente de novo em instantes.';
  }
}
