import 'package:flutter/material.dart';

import '../core/theme/zena_cores.dart';

class LinkAuth extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;

  const LinkAuth({super.key, required this.texto, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: context.zena.link),
      child: Text(texto),
    );
  }
}
