import 'package:flutter/material.dart';

class CamposValoresRow extends StatelessWidget {
  final TextEditingController salarioController;
  final TextEditingController gastosController;
  final TextEditingController nomeGastoController;

  const CamposValoresRow({
    super.key,
    required this.salarioController,
    required this.gastosController,
    required this.nomeGastoController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: salarioController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Salário',
              hintText: '2000.00',
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: nomeGastoController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Nome do gasto',
              hintText: 'Gasolina',
              prefixIcon: Icon(Icons.label_outline),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: gastosController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Preço',
              hintText: '160.00',
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
        ),
      ],
    );
  }
}