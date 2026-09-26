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

class LoginScreen extends StatefulWidget {
  final AuthService authService;
  final ThemeController themeController;

  const LoginScreen({
    super.key,
    required this.authService,
    required this.themeController,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (_carregando) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      await widget.authService.entrar(
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
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
      titulo: 'Bem-vindo de volta',
      subtitulo: 'Entre para ver como está o seu mês.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _entrar(),
              autofillHints: const [AutofillHints.password],
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
              texto: 'Entrar',
              carregando: _carregando,
              onPressed: _entrar,
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Ainda não tem conta?',
                  style: TextStyle(color: context.zena.textoSecundario),
                ),
                LinkAuth(
                  texto: 'Criar conta',
                  onPressed: _carregando
                      ? null
                      : () => Navigator.of(context).pushNamed(AppRoutes.cadastro),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
