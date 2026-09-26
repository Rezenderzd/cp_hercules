import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart';
import 'financas_repository.dart';
import 'mock_financas_repository.dart';
import 'supabase_auth_service.dart';
import 'supabase_financas_repository.dart';

FinancasRepository criarFinancasRepository(AuthService authService) {
  if (authService is SupabaseAuthService) {
    return SupabaseFinancasRepository(Supabase.instance.client);
  }
  return MockFinancasRepository();
}
