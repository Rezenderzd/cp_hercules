import 'package:flutter/material.dart';

import '../core/theme/app_typography.dart';
import '../core/theme/zena_cores.dart';
import '../core/utils/moeda.dart';
import '../models/investimento.dart';
import 'risco_chip.dart';

class InvestimentoCard extends StatelessWidget {
  final Investimento investimento;
  final double valor;

  const InvestimentoCard({
    super.key,
    required this.investimento,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;
    final inv = investimento;
    final simulando = valor > 0;

    return Card(
      color: cores.cartao,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inv.nome,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        inv.descricao,
                        style: textTheme.bodySmall?.copyWith(
                          color: cores.textoSecundario,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                RiscoChip(risco: inv.risco),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Dado(
                    rotulo: 'Rentabilidade',
                    valor: '${formatarPercentual(inv.rentabilidadeAnual)} ao ano',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Dado(
                    rotulo: 'Retorno em 12 meses',
                    valor: simulando
                        ? '+ ${formatarReais(inv.retornoEm12Meses(valor))}'
                        : '—',
                    corValor: simulando ? cores.sucesso : null,
                    complemento: simulando
                        ? 'Total: ${formatarReais(inv.totalEm12Meses(valor))}'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Chance de dar errado: ${inv.chanceDeErroPct}%',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: inv.chanceDeErroPct / 100,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
              color: corDoRisco(inv.risco),
              backgroundColor: cores.divisor,
            ),
            const SizedBox(height: 8),
            Text(
              simulando
                  ? 'Se der errado: perda de até '
                      '${formatarReais(inv.perdaMaxima(valor))} '
                      '(${inv.perdaSeErrarPct}%)'
                  : 'Se der errado: perda de até '
                      '${inv.perdaSeErrarPct}% do valor investido',
              style: textTheme.bodySmall?.copyWith(color: cores.textoSecundario),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dado extends StatelessWidget {
  final String rotulo;
  final String valor;
  final Color? corValor;
  final String? complemento;

  const _Dado({
    required this.rotulo,
    required this.valor,
    this.corValor,
    this.complemento,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rotulo,
          style: textTheme.bodySmall?.copyWith(color: cores.textoSecundario),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            valor,
            style: AppTypography.numero(fontSize: 18, color: corValor),
          ),
        ),
        if (complemento != null) ...[
          const SizedBox(height: 2),
          Text(
            complemento!,
            style: textTheme.bodySmall?.copyWith(color: cores.textoSecundario),
          ),
        ],
      ],
    );
  }
}
