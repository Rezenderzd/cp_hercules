import 'package:flutter/material.dart';

import '../core/theme/zena_cores.dart';

/// Atalho em formato de card para outra página (ex.: Investimentos).
class AtalhoCard extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const AtalhoCard({
    super.key,
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;

    return Card(
      color: cores.cartao,
      elevation: 1,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icone, color: cores.icone),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitulo,
          style: TextStyle(color: cores.textoSecundario),
        ),
        trailing: Icon(Icons.chevron_right, color: cores.textoSecundario),
        onTap: onTap,
      ),
    );
  }
}
