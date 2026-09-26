import 'package:flutter/material.dart';

import '../core/theme/zena_cores.dart';

class FaixaTitulo extends StatelessWidget {
  final String titulo;
  final String subtitulo;

  const FaixaTitulo({super.key, required this.titulo, required this.subtitulo});

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      color: cores.marca,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: textTheme.headlineSmall?.copyWith(
              color: cores.sobreMarca,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: textTheme.bodyMedium?.copyWith(
              color: cores.sobreMarca.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
