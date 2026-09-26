import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../env.dart';
import 'auth_service.dart';
import 'mock_auth_service.dart';
import 'supabase_auth_service.dart';

Future<AuthService> criarAuthService() async {
  if (!Env.supabaseConfigurado) {
    debugPrint('Zena+: Supabase não configurado, usando login mock.');
    return MockAuthService();
  }

  try {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
    );
    debugPrint('Zena+: Supabase conectado em ${Env.supabaseUrl}');
    return SupabaseAuthService(Supabase.instance.client);
  } catch (erro) {
    debugPrint('Zena+: falha ao iniciar o Supabase ($erro), usando login mock.');
    return MockAuthService();
  }
}
