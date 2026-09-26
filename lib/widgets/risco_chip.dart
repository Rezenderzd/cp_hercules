import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/investimento.dart';

Color corDoRisco(RiscoInvestimento risco) {
  return switch (risco) {
    RiscoInvestimento.baixo => AppColors.riscoBaixo,
    RiscoInvestimento.medio => AppColors.riscoMedio,
    RiscoInvestimento.alto => AppColors.riscoAlto,
  };
}

class RiscoChip extends StatelessWidget {
  final RiscoInvestimento risco;

  const RiscoChip({super.key, required this.risco});

  @override
  Widget build(BuildContext context) {
    final corTexto =
        risco == RiscoInvestimento.medio ? AppColors.grafite : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: corDoRisco(risco),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        risco.rotulo,
        style: TextStyle(
          color: corTexto,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
