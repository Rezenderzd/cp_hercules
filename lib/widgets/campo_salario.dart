import 'package:flutter/material.dart';

class CampoSalario extends StatelessWidget {
  final TextEditingController controller;

  const CampoSalario({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Salário',
        hintText: '2000.00',
        prefixIcon: Icon(Icons.attach_money),
      ),
    );
  }
}