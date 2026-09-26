import 'package:flutter/material.dart';

class BotoesEnviarRow extends StatelessWidget {
  final VoidCallback onEnviarSalario;
  final VoidCallback onEnviarGasto;

  const BotoesEnviarRow({
    super.key,
    required this.onEnviarSalario,
    required this.onEnviarGasto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onEnviarSalario,
            child: const Text('Salvar Salário'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onEnviarGasto,
            child: const Text('Adicionar Gasto'),
          ),
        ),
      ],
    );
  }
}