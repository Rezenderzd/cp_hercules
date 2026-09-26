import 'package:flutter/material.dart';

import '../core/theme/zena_cores.dart';

class CampoSenha extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;

  const CampoSenha({
    super.key,
    required this.controller,
    this.label = 'Senha',
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.autofillHints,
  });

  @override
  State<CampoSenha> createState() => _CampoSenhaState();
}

class _CampoSenhaState extends State<CampoSenha> {
  bool _ocultar = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _ocultar,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofillHints: widget.autofillHints,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _ocultar ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: context.zena.textoSecundario,
          ),
          tooltip: _ocultar ? 'Mostrar senha' : 'Ocultar senha',
          onPressed: () => setState(() => _ocultar = !_ocultar),
        ),
      ),
    );
  }
}
