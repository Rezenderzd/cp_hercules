import 'package:flutter/material.dart';

import '../core/theme/zena_cores.dart';
import '../models/gasto.dart';

class ResultadoEdicaoGasto {
  final Gasto gasto;
  final bool excluir;

  const ResultadoEdicaoGasto.salvar(this.gasto) : excluir = false;
  const ResultadoEdicaoGasto.excluir(this.gasto) : excluir = true;
}

class EditarGastoDialog extends StatefulWidget {
  final Gasto gasto;

  const EditarGastoDialog({super.key, required this.gasto});

  @override
  State<EditarGastoDialog> createState() => _EditarGastoDialogState();
}

class _EditarGastoDialogState extends State<EditarGastoDialog> {
  late final TextEditingController _nomeController =
      TextEditingController(text: widget.gasto.nome);
  late final TextEditingController _precoController =
      TextEditingController(text: widget.gasto.preco.toStringAsFixed(2));

  String? _erro;

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  void _salvar() {
    final nome = _nomeController.text.trim();
    final preco =
        double.tryParse(_precoController.text.trim().replaceAll(',', '.')) ??
            0.0;

    if (nome.isEmpty || preco <= 0) {
      setState(() => _erro = 'Informe o nome e um preço maior que zero.');
      return;
    }

    Navigator.of(context).pop(
      ResultadoEdicaoGasto.salvar(widget.gasto.copyWith(nome: nome, preco: preco)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;

    return AlertDialog(
      backgroundColor: cores.cartao,
      surfaceTintColor: Colors.transparent,
      title: const Text('Editar gasto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do gasto',
                prefixIcon: Icon(Icons.label_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _precoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Preço',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            if (_erro != null) ...[
              const SizedBox(height: 12),
              Text(
                _erro!,
                style: TextStyle(
                  color: cores.alerta,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: cores.alerta),
          onPressed: () => Navigator.of(context)
              .pop(ResultadoEdicaoGasto.excluir(widget.gasto)),
          child: const Text('Excluir'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _salvar,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
