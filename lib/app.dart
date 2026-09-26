import 'package:flutter/material.dart';

import 'core/routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'screens/login/cadastro_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/main/main_screen.dart';
import 'services/auth_service.dart';
import 'services/financas_repository.dart';

class ZenaApp extends StatelessWidget {
  final AuthService authService;
  final FinancasRepository financasRepository;
  final ThemeController themeController;

  const ZenaApp({
    super.key,
    required this.authService,
    required this.financasRepository,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Zena+',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.modo,
          initialRoute:
              authService.estaLogado ? AppRoutes.home : AppRoutes.login,
          routes: {
            AppRoutes.login: (context) => LoginScreen(
                  authService: authService,
                  themeController: themeController,
                ),
            AppRoutes.cadastro: (context) => CadastroScreen(
                  authService: authService,
                  themeController: themeController,
                ),
            AppRoutes.home: (context) => MainScreen(
                  authService: authService,
                  financasRepository: financasRepository,
                  themeController: themeController,
                ),
          },
        );
      },
    );
  }
}
