import 'package:flutter/material.dart';

import '../core/theme/zena_cores.dart';
import '../models/gasto.dart';

class ListaGastosDisplay extends StatelessWidget {
  final List<Gasto> gastos;

  final ValueChanged<Gasto>? onSelecionar;

  const ListaGastosDisplay({
    super.key,
    required this.gastos,
    this.onSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;

    if (gastos.isEmpty) {
      return Text(
        'Nenhum gasto cadastrado.',
        style: TextStyle(color: cores.textoSecundario, fontSize: 14),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onSelecionar != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'Toque em um gasto para editar ou excluir.',
              style: TextStyle(color: cores.textoSecundario, fontSize: 12),
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gastos.length,
          itemBuilder: (context, index) {
            final gastoItem = gastos[index];

            return Card(
              color: cores.cartao,
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Icon(Icons.shopping_cart, color: cores.icone),
                title: Text(gastoItem.nome),
                trailing: Text(
                  'R\$ ${gastoItem.preco.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cores.gasto,
                  ),
                ),
                onTap: onSelecionar == null
                    ? null
                    : () => onSelecionar!(gastoItem),
              ),
            );
          },
        ),
      ],
    );
  }
}
