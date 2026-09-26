import 'package:flutter/material.dart';

import '../../models/gasto.dart';
import '../../services/auth_service.dart';
import '../../services/financas_repository.dart';
import '../../widgets/boas_vindas_header.dart';
import '../../widgets/botoes_enviar_row.dart';
import '../../widgets/campos_valores_row.dart';
import '../../widgets/editar_gasto_dialog.dart';
import '../../widgets/erro_carga_card.dart';
import '../../widgets/lista_gastos_display.dart';
import '../../widgets/resultado_display.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  final FinancasRepository financasRepository;

  const HomeScreen({
    super.key,
    required this.authService,
    required this.financasRepository,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _salarioController = TextEditingController();
  final TextEditingController _gastosController = TextEditingController();
  final TextEditingController _nomeGastoController = TextEditingController();

  double _salario = 0.0;
  final List<Gasto> _gastos = [];

  bool _carregando = true;
  bool _processando = false;
  String? _erroCarga;

  FinancasRepository get _repo => widget.financasRepository;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _salarioController.dispose();
    _gastosController.dispose();
    _nomeGastoController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    try {
      final salario = await _repo.buscarSalario();
      final gastos = await _repo.listarGastos();
      if (!mounted) return;
      setState(() {
        _salario = salario;
        _gastos
          ..clear()
          ..addAll(gastos);
        _carregando = false;
      });
    } on FinancasFalha catch (falha) {
      if (!mounted) return;
      setState(() {
        _erroCarga = falha.mensagem;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erroCarga = 'Algo deu errado ao carregar. Tente de novo.';
        _carregando = false;
      });
    }
  }

  void _tentarDeNovo() {
    setState(() {
      _carregando = true;
      _erroCarga = null;
    });
    _carregar();
  }

  void _avisar(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> _executar(Future<void> Function() acao) async {
    if (_processando) return;
    setState(() => _processando = true);
    try {
      await acao();
    } on FinancasFalha catch (falha) {
      _avisar(falha.mensagem);
    } catch (_) {
      _avisar('Algo deu errado. Tente de novo em instantes.');
    } finally {
      if (mounted) setState(() => _processando = false);
    }
  }

  Future<void> _processarSalario() async {
    final texto = _salarioController.text.trim().replaceAll(',', '.');
    final valor = double.tryParse(texto);

    if (valor == null || valor < 0) {
      _avisar('Digite um salário válido.');
      return;
    }

    await _executar(() async {
      await _repo.salvarSalario(valor);
      if (!mounted) return;
      setState(() {
        _salario = valor;
        _salarioController.clear();
      });
    });
  }

  Future<void> _processarGasto() async {
    final nome = _nomeGastoController.text.trim();
    final preco =
        double.tryParse(_gastosController.text.trim().replaceAll(',', '.')) ??
            0.0;

    if (nome.isEmpty || preco <= 0) {
      _avisar('Informe o nome do gasto e um preço maior que zero.');
      return;
    }

    await _executar(() async {
      final novo = await _repo.adicionarGasto(nome: nome, preco: preco);
      if (!mounted) return;
      setState(() {
        _gastos.add(novo);
        _gastosController.clear();
        _nomeGastoController.clear();
      });
    });
  }

  Future<void> _editarGasto(Gasto gasto) async {
    final resultado = await showDialog<ResultadoEdicaoGasto>(
      context: context,
      builder: (_) => EditarGastoDialog(gasto: gasto),
    );
    if (resultado == null || !mounted) return;

    await _executar(() async {
      if (resultado.excluir) {
        final id = gasto.id;
        if (id == null) return;
        await _repo.removerGasto(id);
        if (!mounted) return;
        setState(() => _gastos.removeWhere((g) => g.id == id));
      } else {
        final atualizado = await _repo.atualizarGasto(resultado.gasto);
        if (!mounted) return;
        setState(() {
          final indice = _gastos.indexWhere((g) => g.id == atualizado.id);
          if (indice != -1) _gastos[indice] = atualizado;
        });
      }
    });
  }

  double get _totalGastos => _gastos.fold(0, (soma, item) => soma + item.preco);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BoasVindasHeader(nome: widget.authService.nomeUsuario),
          SizedBox(
            height: 3,
            child: (_carregando || _processando)
                ? const LinearProgressIndicator()
                : null,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
            child: Column(
              children: [
                if (_erroCarga != null) ...[
                  ErroCargaCard(
                    mensagem: _erroCarga!,
                    onTentarDeNovo: _tentarDeNovo,
                  ),
                  const SizedBox(height: 16),
                ],

                CamposValoresRow(
                  salarioController: _salarioController,
                  gastosController: _gastosController,
                  nomeGastoController: _nomeGastoController,
                ),

                const SizedBox(height: 16),

                BotoesEnviarRow(
                  onEnviarSalario: _processarSalario,
                  onEnviarGasto: _processarGasto,
                ),

                const SizedBox(height: 24),

                ResultadoDisplay(
                  salario: _salario,
                  totalGastos: _totalGastos,
                  quantidadeGastos: _gastos.length,
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                ListaGastosDisplay(
                  gastos: _gastos,
                  onSelecionar: _editarGasto,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}