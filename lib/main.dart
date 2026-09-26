import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/theme/theme_controller.dart';
import 'services/auth_service_factory.dart';
import 'services/financas_repository_factory.dart';

Future<void> _carregarEnv() async {
  try {
    await dotenv.load();
  } catch (_) {
    debugPrint(
      'Zena+: .env não encontrado. Copie .env.example para .env se quiser usar o Supabase.',
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _carregarEnv();

  final authService = await criarAuthService();
  final financasRepository = criarFinancasRepository(authService);
  final themeController = ThemeController();

  runApp(
    ZenaApp(
      authService: authService,
      financasRepository: financasRepository,
      themeController: themeController,
    ),
  );
}
