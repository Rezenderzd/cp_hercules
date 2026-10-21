import 'package:flutter/material.dart';

import '../../core/theme/zena_cores.dart';
import '../../core/utils/moeda.dart';
import '../../models/investimento.dart';
import '../../services/investimentos_service.dart';
import '../../widgets/botao_principal.dart';
import '../../widgets/erro_carga_card.dart';
import '../../widgets/faixa_titulo.dart';
import '../../widgets/investimento_card.dart';

class InvestimentosScreen extends StatefulWidget {
  final InvestimentosService service;

  const InvestimentosScreen({super.key, required this.service});

  @override
  State<InvestimentosScreen> createState() => _InvestimentosScreenState();
}

class _InvestimentosScreenState extends State<InvestimentosScreen> {
  final TextEditingController _valorController = TextEditingController();

  double _valor = 0.0;
  String? _erro;

  bool _carregando = true;
  List<Investimento> _opcoes = const [];
  List<String> _fontesComFalha = const [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final resultado = await widget.service.buscarOpcoes();
    if (!mounted) return;

    final ordenadas = [...resultado.opcoes]
      ..sort((a, b) {
        final porRisco = a.risco.index.compareTo(b.risco.index);
        if (porRisco != 0) return porRisco;
        return a.rentabilidadePct.compareTo(b.rentabilidadePct);
      });

    setState(() {
      _opcoes = ordenadas;
      _fontesComFalha = resultado.fontesComFalha;
      _carregando = false;
    });
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
                    const SizedBox(height: 4),
                    Text(
                      'Dados reais do Banco Central e da bolsa (brapi.dev). '
                      'Rentabilidade bruta, antes do Imposto de Renda. '
                      'O resultado passado das ações não garante o futuro.',
                      style: textTheme.bodySmall?.copyWith(
                        color: cores.textoSecundario,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._conteudo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _conteudo() {
    if (_carregando) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    return [
      if (_fontesComFalha.isNotEmpty) ...[
        ErroCargaCard(
          mensagem: 'Não foi possível carregar: ${_fontesComFalha.join(' e ')}. '
              'Confira a internet e tente de novo.',
          onTentarDeNovo: _carregar,
        ),
        const SizedBox(height: 8),
      ],
      for (final investimento in _opcoes)
        InvestimentoCard(investimento: investimento, valor: _valor),
    ];
  }
}
