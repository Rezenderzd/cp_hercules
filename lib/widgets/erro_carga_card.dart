import 'package:flutter/material.dart';

import '../core/theme/zena_cores.dart';

class ErroCargaCard extends StatelessWidget {
  final String mensagem;
  final VoidCallback onTentarDeNovo;

  const ErroCargaCard({
    super.key,
    required this.mensagem,
    required this.onTentarDeNovo,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cores.cartao,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cores.alerta),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mensagem,
            style: TextStyle(color: cores.alerta, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onTentarDeNovo,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar de novo'),
          ),
        ],
      ),
    );
  }
}
