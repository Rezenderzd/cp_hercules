import 'package:flutter/material.dart';

import '../core/theme/zena_cores.dart';
import '../core/theme/app_typography.dart';

class ResultadoDisplay extends StatelessWidget {
  final double salario;
  final double totalGastos;
  final int quantidadeGastos;

  const ResultadoDisplay({
    super.key,
    required this.salario,
    required this.totalGastos,
    required this.quantidadeGastos,
  });

  @override
  Widget build(BuildContext context) {
    final saldoRestante = salario - totalGastos;

    return Column(
      children: [
        Text(
          'Salário: R\$ ${salario.toStringAsFixed(2)} | Total Gastos: R\$ ${totalGastos.toStringAsFixed(2)}',
          style: AppTypography.numero(),
        ),
        const SizedBox(height: 8),
        Text(
          'Saldo Restante: R\$ ${saldoRestante.toStringAsFixed(2)}',
          style: AppTypography.numero(color: context.zena.sucesso),
        ),
      ],
    );
  }
}
