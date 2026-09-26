import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/theme/zena_cores.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_scaffold.dart';
import '../../widgets/botao_principal.dart';
import '../../widgets/campo_senha.dart';
import '../../widgets/link_auth.dart';

class CadastroScreen extends StatefulWidget {
  final AuthService authService;
  final ThemeController themeController;

  const CadastroScreen({
    super.key,
    required this.authService,
    required this.themeController,
  });

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _criarConta() async {
    if (_carregando) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      await widget.authService.criarConta(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (rota) => false,
      );
    } on AuthFalha catch (falha) {
      if (!mounted) return;
      setState(() {
        _erro = falha.mensagem;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erro = 'Algo deu errado. Tente de novo em instantes.';
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      themeController: widget.themeController,
      titulo: 'Crie sua conta',
      subtitulo: 'Comece pelo básico. Sempre tem um próximo passo.',
      onVoltar: () => Navigator.of(context).pop(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nomeController,
              validator: Validators.nome,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.givenName],
              decoration: const InputDecoration(
                labelText: 'Nome',
                hintText: 'Como você quer ser chamado',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              validator: Validators.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'E-mail',
                hintText: 'voce@email.com',
                prefixIcon: Icon(Icons.mail_outline),
              ),
            ),
            const SizedBox(height: 16),
            CampoSenha(
              controller: _senhaController,
              validator: Validators.senha,
              autofillHints: const [AutofillHints.newPassword],
            ),
            const SizedBox(height: 16),
            CampoSenha(
              controller: _confirmarSenhaController,
              label: 'Confirmar senha',
              validator: Validators.confirmarSenha(() => _senhaController.text),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _criarConta(),
            ),
            const SizedBox(height: 16),
            if (_erro != null) ...[
              Text(
                _erro!,
                style: TextStyle(
                  color: context.zena.alerta,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
            ],
            BotaoPrincipal(
              texto: 'Criar conta',
              carregando: _carregando,
              onPressed: _criarConta,
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Já tem conta?',
                  style: TextStyle(color: context.zena.textoSecundario),
                ),
                LinkAuth(
                  texto: 'Entrar',
                  onPressed:
                      _carregando ? null : () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
