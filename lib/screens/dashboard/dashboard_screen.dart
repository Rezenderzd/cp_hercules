import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/theme/zena_cores.dart';
import '../../core/utils/gastos_mensais.dart';
import '../../core/utils/moeda.dart';
import '../../data/historico_mock.dart';
import '../../models/gasto.dart';
import '../../models/salario_mensal.dart';
import '../../services/financas_repository.dart';
import '../../widgets/erro_carga_card.dart';
import '../../widgets/faixa_titulo.dart';
import '../../widgets/grafico_salarios_mensais.dart';

class DashboardScreen extends StatefulWidget {
  final FinancasRepository financasRepository;
  final DateTime contaCriadaEm;

  const DashboardScreen({
    super.key,
    required this.financasRepository,
    required this.contaCriadaEm,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Gasto> _gastos = const [];
  List<SalarioMensal> _historicoSalarios = const [];
  double _salarioAtual = 0.0;
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final gastos = await widget.financasRepository.listarGastos();
      final historicoSalarios =
          await widget.financasRepository.listarHistoricoSalarios();
      final salarioAtual = await widget.financasRepository.buscarSalario();
      if (!mounted) return;
      setState(() {
        _gastos = gastos;
        _historicoSalarios = historicoSalarios;
        _salarioAtual = salarioAtual;
        _carregando = false;
        _erro = null;
      });
    } on FinancasFalha catch (falha) {
      if (!mounted) return;
      setState(() {
        _erro = falha.mensagem;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erro = 'Algo deu errado ao carregar o painel. Tente de novo.';
        _carregando = false;
      });
    }
  }

  void _tentarDeNovo() {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const FaixaTitulo(
            titulo: 'Painel',
            subtitulo: 'Veja quanto você gastou em cada mês.',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: _conteudo(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _conteudo() {
    if (_carregando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_erro != null) {
      return ErroCargaCard(mensagem: _erro!, onTentarDeNovo: _tentarDeNovo);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _GraficoGastosMensais(
          key: const Key('grafico_gastos'),
          gastos: _gastos,
          contaCriadaEm: widget.contaCriadaEm,
        ),
        const SizedBox(height: 64),
        const Divider(),
        const SizedBox(height: 64),
        GraficoSalariosMensais(
          key: const Key('grafico_salarios'),
          historico: _historicoSalarios,
          salarioAtual: _salarioAtual,
          contaCriadaEm: widget.contaCriadaEm,
        ),
      ],
    );
  }
}

class _GraficoGastosMensais extends StatelessWidget {
  final List<Gasto> gastos;
  final DateTime contaCriadaEm;

  const _GraficoGastosMensais({
    super.key,
    required this.gastos,
    required this.contaCriadaEm,
  });

  static const _quantidadeMeses = 6;

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;
    final agora = DateTime.now();
    final totais = totalGastoPorMes(
      gastos,
      quantidadeMeses: _quantidadeMeses,
      agora: agora,
      valorFixoDoMes: (mes) => gastoMockDoMes(mes, contaCriadaEm),
    );
    final maiorValor =
        totais.fold<double>(0, (m, t) => t.total > m ? t.total : m);
    final tetoEixoY = maiorValor <= 0 ? 100.0 : maiorValor * 1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Gastos por mês',
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'O mês atual continua mudando; os anteriores ficam fixos.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: cores.textoSecundario),
        ),
        if (totais.any((m) => ehMesMockado(m.mes, contaCriadaEm))) ...[
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
                for (var i = 0; i < totais.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: totais[i].total,
                        color: mesmoMesEAno(totais[i].mes, agora)
                            ? cores.marca
                            : cores.borda,
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
                      if (indice < 0 || indice >= totais.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          rotuloMesAbreviado(totais[indice].mes),
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
        for (final total in totais.reversed)
          _LinhaMes(total: total, ehMesAtual: mesmoMesEAno(total.mes, agora)),
      ],
    );
  }
}

class _LinhaMes extends StatelessWidget {
  final TotalMensal total;
  final bool ehMesAtual;

  const _LinhaMes({required this.total, required this.ehMesAtual});

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: ehMesAtual ? cores.marca : cores.borda,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ehMesAtual
                  ? '${rotuloMesPorExtenso(total.mes)} (em andamento)'
                  : rotuloMesPorExtenso(total.mes),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: ehMesAtual ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            formatarReais(total.total),
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
