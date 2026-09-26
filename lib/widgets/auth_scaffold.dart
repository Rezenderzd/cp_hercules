import 'package:flutter/material.dart';

import '../core/theme/theme_controller.dart';
import '../core/theme/zena_cores.dart';
import 'auth_header.dart';

class AuthScaffold extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final Widget child;
  final ThemeController themeController;
  final VoidCallback? onVoltar;

  const AuthScaffold({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.child,
    required this.themeController,
    this.onVoltar,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cores = context.zena;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthHeader(themeController: themeController, onVoltar: onVoltar),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cores.texto,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitulo,
                        style: textTheme.bodyMedium?.copyWith(
                          color: cores.textoSecundario,
                        ),
                      ),
                      const SizedBox(height: 28),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
