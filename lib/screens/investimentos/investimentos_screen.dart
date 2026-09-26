import 'package:flutter/material.dart';

import '../../core/theme/zena_cores.dart';
import '../../core/utils/moeda.dart';
import '../../data/investimentos_mock.dart';
import '../../models/investimento.dart';
import '../../widgets/botao_principal.dart';
import '../../widgets/faixa_titulo.dart';
import '../../widgets/investimento_card.dart';

class InvestimentosScreen extends StatefulWidget {
  final List<Investimento> opcoes;

  const InvestimentosScreen({super.key, this.opcoes = investimentosMock});

  @override
  State<InvestimentosScreen> createState() => _InvestimentosScreenState();
}

class _InvestimentosScreenState extends State<InvestimentosScreen> {
  final TextEditingController _valorController = TextEditingController();

  double _valor = 0.0;
  String? _erro;

  late final List<Investimento> _ordenadas = [...widget.opcoes]
    ..sort((a, b) {
      final porRisco = a.risco.index.compareTo(b.risco.index);
      if (porRisco != 0) return porRisco;
      return a.rentabilidadeAnual.compareTo(b.rentabilidadeAnual);
    });

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  void _simular() {
    final valor = lerValor(_valorController.text);

    if (valor == null || valor <= 0) {
      setState(() => _erro = 'Digite um valor maior que zero.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _valor = valor;
      _erro = null;
      _valorController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
    child: Column(
      children: [
        const FaixaTitulo(
          titulo: 'Investimentos',
          subtitulo: 'Simule quanto o seu dinheiro pode render em 12 meses.',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _valorController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _simular(),
                    decoration: InputDecoration(
                      labelText: 'Quanto você quer investir?',
                      hintText: '5000,00',
                      prefixIcon: const Icon(Icons.attach_money),
                      errorText: _erro,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BotaoPrincipal(texto: 'Simular', onPressed: _simular),
                  const SizedBox(height: 24),
                  Text(
                    _valor > 0
                        ? 'Simulação para ${formatarReais(_valor)} em 12 meses'
                        : 'Informe um valor para ver quanto cada opção pode render.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: cores.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Opções de investimento',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final investimento in _ordenadas)
                    InvestimentoCard(
                      investimento: investimento,
                      valor: _valor,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }
}
