import 'package:flutter/material.dart';

import '../core/theme/theme_controller.dart';

class BotaoTema extends StatelessWidget {
  final ThemeController controller;
  final Color? cor;

  const BotaoTema({super.key, required this.controller, this.cor});

  @override
  Widget build(BuildContext context) {
    final estaEscuro = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(
        estaEscuro ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      ),
      color: cor,
      tooltip: estaEscuro ? 'Modo claro' : 'Modo noturno',
      onPressed: () => controller.alternar(estaEscuro: estaEscuro),
    );
  }
}
