/// Configuração do Supabase.
///
/// ATENÇÃO: o repositório é público. NÃO escreva a URL/chave reais aqui.
/// Passe os valores na hora de rodar, com --dart-define:
///
///   flutter run \
///     --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///     --dart-define=SUPABASE_ANON_KEY=eyJ...
///
/// Use somente a chave "anon" (pública). A chave "service_role" NUNCA deve
/// entrar no app.
///
/// Enquanto os valores abaixo forem os placeholders, o app usa o login MOCK
/// (ver services/mock_auth_service.dart), então dá pra demonstrar o fluxo
/// completo sem backend.
class SupabaseConfig {
  SupabaseConfig._();

  static const String _urlPlaceholder = 'https://SEU-PROJETO.supabase.co';
  static const String _anonKeyPlaceholder = 'SUA-CHAVE-ANON-AQUI';

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: _urlPlaceholder,
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: _anonKeyPlaceholder,
  );

  /// true quando URL e chave foram informadas via --dart-define.
  static bool get configurado =>
      url != _urlPlaceholder && anonKey != _anonKeyPlaceholder;

  /// Enquanto não estiver configurado, o app usa o login mock.
  static bool get usarMock => !configurado;
}
