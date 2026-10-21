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

    final ehAcao = inv.tipo == TipoInvestimento.acao;
    final retorno = inv.retornoEm12Meses(valor);
    final corRetorno = retorno >= 0 ? cores.sucesso : cores.alerta;

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
                    rotulo: ehAcao ? 'Últimos 12 meses' : 'Rentabilidade',
                    valor: ehAcao
                        ? _comSinal(formatarPercentual(inv.rentabilidadePct.abs()), inv.rentabilidadePct)
                        : '${formatarPercentual(inv.rentabilidadePct)} ao ano',
                    corValor: ehAcao
                        ? (inv.rentabilidadePct >= 0 ? cores.sucesso : cores.alerta)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Dado(
                    rotulo: ehAcao
                        ? 'Se repetir os últimos 12 meses'
                        : 'Retorno em 12 meses',
                    valor: simulando
                        ? _comSinal(formatarReais(retorno.abs()), retorno)
                        : '—',
                    corValor: simulando ? corRetorno : null,
                    complemento: simulando
                        ? 'Total: ${formatarReais(inv.totalEm12Meses(valor))}'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Chance de prejuízo: ${formatarPercentual(inv.chanceDePrejuizoPct)}',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: inv.chanceDePrejuizoPct / 100,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
              color: corDoRisco(inv.risco),
              backgroundColor: cores.divisor,
            ),
            const SizedBox(height: 8),
            Text(
              ehAcao
                  ? 'Em ${formatarPercentual(inv.chanceDePrejuizoPct)} dos dias do último ano, '
                      'quem comprou está no prejuízo hoje.'
                  : 'Rende todo dia, sem risco de o valor investido cair.',
              style: textTheme.bodySmall?.copyWith(color: cores.textoSecundario),
            ),
            const SizedBox(height: 8),
            Text(
              ehAcao
                  ? (simulando
                      ? 'Maior queda nos últimos 12 meses: ${formatarPercentual(inv.maiorQuedaPct)} '
                          '(${formatarReais(inv.perdaNaMaiorQueda(valor))} sobre o valor simulado)'
                      : 'Maior queda nos últimos 12 meses: ${formatarPercentual(inv.maiorQuedaPct)}')
                  : (inv.garantia ?? ''),
              style: textTheme.bodySmall?.copyWith(color: cores.textoSecundario),
            ),
            const SizedBox(height: 8),
            Text(
              'Fonte: ${inv.fonte}',
              style: textTheme.bodySmall?.copyWith(
                color: cores.textoSecundario,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _comSinal(String texto, double numero) =>
      numero >= 0 ? '+ $texto' : '- $texto';
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
