import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/zena_cores.dart';
import '../core/utils/gastos_mensais.dart';
import '../core/utils/moeda.dart';
import '../core/utils/salarios_mensais.dart';
import '../data/historico_mock.dart';
import '../models/salario_mensal.dart';

class GraficoSalariosMensais extends StatelessWidget {
  final List<SalarioMensal> historico;
  final double salarioAtual;
  final DateTime contaCriadaEm;
  final int quantidadeMeses;

  const GraficoSalariosMensais({
    super.key,
    required this.historico,
    required this.salarioAtual,
    required this.contaCriadaEm,
    this.quantidadeMeses = 6,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;
    final agora = DateTime.now();
    final meses = salarioPorMes(
      historico,
      quantidadeMeses: quantidadeMeses,
      agora: agora,
      salarioAtual: salarioAtual,
      valorFixoDoMes: (mes) => patrimonioMockDoMes(mes, contaCriadaEm),
    );
    final maiorValor = meses.fold<double>(0, (m, s) => s.valor > m ? s.valor : m);
    final tetoEixoY = maiorValor <= 0 ? 100.0 : maiorValor * 1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Patrimônio por mês',
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'O mês atual usa o salário de agora; os anteriores guardam o último valor salvo em cada mês.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: cores.textoSecundario),
        ),
        if (meses.any((m) => ehMesMockado(m.mes, contaCriadaEm))) ...[
          const SizedBox(height: 4),
          Text(
            'Meses antes da criação da sua conta (${rotuloMesPorExtenso(contaCriadaEm)}) mostram valores de exemplo.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: cores.textoSecundario,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              maxY: tetoEixoY,
              barGroups: [
                for (var i = 0; i < meses.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: meses[i].valor,
                        color: AppColors.sucesso,
                        width: 22,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
              ],
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: tetoEixoY / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: cores.divisor,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    interval: tetoEixoY / 4,
                    getTitlesWidget: (valor, meta) => Text(
                      formatarReaisResumido(valor),
                      style: TextStyle(fontSize: 10, color: cores.textoSecundario),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (valor, meta) {
                      final indice = valor.toInt();
                      if (indice < 0 || indice >= meses.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          rotuloMesAbreviado(meses[indice].mes),
                          style: TextStyle(
                            fontSize: 11,
                            color: cores.textoSecundario,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        for (var i = meses.length - 1; i >= 0; i--)
          _LinhaSalario(
            atual: meses[i],
            anterior: i > 0 ? meses[i - 1] : null,
            ehMesAtual: i == meses.length - 1,
          ),
      ],
    );
  }
}

class _LinhaSalario extends StatelessWidget {
  final SalarioMensal atual;
  final SalarioMensal? anterior;
  final bool ehMesAtual;

  const _LinhaSalario({
    required this.atual,
    this.anterior,
    this.ehMesAtual = false,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;
    final variacao = anterior == null ? null : atual.valor - anterior!.valor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.sucesso,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ehMesAtual
                  ? '${rotuloMesPorExtenso(atual.mes)} (atual)'
                  : rotuloMesPorExtenso(atual.mes),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: ehMesAtual ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          if (variacao != null && variacao != 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    variacao > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: variacao > 0 ? AppColors.sucesso : cores.alerta,
                  ),
                  Text(
                    '${variacao > 0 ? '+' : '-'}${formatarReais(variacao.abs())}',
                    style: TextStyle(
                      fontSize: 12,
                      color: variacao > 0 ? AppColors.sucesso : cores.alerta,
                    ),
                  ),
                ],
              ),
            ),
          Text(
            formatarReais(atual.valor),
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
