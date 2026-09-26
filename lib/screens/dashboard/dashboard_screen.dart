import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/theme/zena_cores.dart';
import '../../core/utils/moeda.dart';
import '../../core/utils/orcamento_grafico.dart';
import '../../models/gasto.dart';
import '../../services/financas_repository.dart';
import '../../widgets/erro_carga_card.dart';
import '../../widgets/faixa_titulo.dart';

class DashboardScreen extends StatefulWidget {
  final FinancasRepository financasRepository;

  const DashboardScreen({super.key, required this.financasRepository});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _salario = 0.0;
  List<Gasto> _gastos = const [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final salario = await widget.financasRepository.buscarSalario();
      final gastos = await widget.financasRepository.listarGastos();
      if (!mounted) return;
      setState(() {
        _salario = salario;
        _gastos = gastos;
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
            subtitulo: 'Veja como o seu salário se distribui entre os gastos.',
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

    if (_salario <= 0) {
      return _AvisoSemSalario();
    }

    return _PainelOrcamento(salario: _salario, gastos: _gastos);
  }
}

class _AvisoSemSalario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cores.cartao,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.pie_chart_outline, size: 48, color: cores.textoSecundario),
          const SizedBox(height: 16),
          Text(
            'Informe o seu salário na aba Início para ver o painel.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: cores.textoSecundario),
          ),
        ],
      ),
    );
  }
}

class _PainelOrcamento extends StatelessWidget {
  final double salario;
  final List<Gasto> gastos;

  const _PainelOrcamento({required this.salario, required this.gastos});

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;
    final resultado = calcularOrcamento(salario: salario, gastos: gastos);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (resultado.orcamentoEstourado) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cores.cartao,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cores.alerta),
            ),
            child: Text(
              'Os gastos somam ${formatarReais(gastos.fold<double>(0, (s, g) => s + g.preco))}, '
              '${formatarReais(resultado.excedente)} a mais que o salário de ${formatarReais(salario)}.',
              style: TextStyle(color: cores.alerta, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'O gráfico abaixo mostra a proporção de cada gasto sobre o total gasto.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(color: cores.textoSecundario),
          ),
          const SizedBox(height: 16),
        ] else ...[
          Text(
            'Salário: ${formatarReais(salario)}',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 32),
        ],
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: [
                for (final fatia in resultado.fatias)
                  PieChartSectionData(
                    value: fatia.valor,
                    color: fatia.cor,
                    radius: 90,
                    title: fatia.percentual >= 6
                        ? '${fatia.percentual.toStringAsFixed(0)}%'
                        : '',
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 48,
            ),
          ),
        ),
        const SizedBox(height: 24),
        for (final fatia in resultado.fatias) _LinhaLegenda(fatia: fatia),
      ],
    );
  }
}

class _LinhaLegenda extends StatelessWidget {
  final FatiaOrcamento fatia;

  const _LinhaLegenda({required this.fatia});

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
            decoration: BoxDecoration(color: fatia.cor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(fatia.nome, style: textTheme.bodyMedium),
          ),
          Text(
            formatarPercentual(fatia.percentual),
            style: textTheme.bodyMedium?.copyWith(
              color: cores.textoSecundario,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formatarReais(fatia.valor),
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
