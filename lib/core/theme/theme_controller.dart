import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({ThemeMode modoInicial = ThemeMode.system})
      : _modo = modoInicial;

  ThemeMode _modo;

  ThemeMode get modo => _modo;

  void definir(ThemeMode novoModo) {
    if (novoModo == _modo) return;
    _modo = novoModo;
    notifyListeners();
  }

  void alternar({required bool estaEscuro}) {
    definir(estaEscuro ? ThemeMode.light : ThemeMode.dark);
  }
}
