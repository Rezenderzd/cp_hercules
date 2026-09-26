import 'package:flutter/material.dart';

import '../core/theme/theme_controller.dart';
import '../core/theme/zena_cores.dart';
import 'botao_tema.dart';

class AuthHeader extends StatelessWidget {
  final ThemeController themeController;
  final VoidCallback? onVoltar;

  const AuthHeader({super.key, required this.themeController, this.onVoltar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.zena.marca,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Center(
                child: Image.asset(
                  'assets/zena-logo-dark-bg.png',
                  height: 64,
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: BotaoTema(
                controller: themeController,
                cor: context.zena.sobreMarca,
              ),
            ),
            if (onVoltar != null)
              Positioned(
                left: 4,
                top: 4,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: context.zena.sobreMarca,
                  tooltip: 'Voltar',
                  onPressed: onVoltar,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
