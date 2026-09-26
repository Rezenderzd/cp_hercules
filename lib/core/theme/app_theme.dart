import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'zena_cores.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _construir(Brightness.light, ZenaCores.claro);

  static ThemeData get dark => _construir(Brightness.dark, ZenaCores.noturno);

  static ThemeData _construir(Brightness brilho, ZenaCores cores) {
    final esquema = ColorScheme.fromSeed(
      seedColor: cores.marca,
      brightness: brilho,
    ).copyWith(
      primary: cores.marca,
      onPrimary: cores.sobreMarca,
      secondary: cores.destaque,
      surface: cores.fundo,
      onSurface: cores.texto,
      onSurfaceVariant: cores.textoSecundario,
      outline: cores.borda,
      outlineVariant: cores.divisor,
      error: cores.alerta,
    );

    final baseTexto = ThemeData(brightness: brilho).textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: cores.fundo,
      textTheme: _textTheme(baseTexto, cores.texto),
      extensions: <ThemeExtension<dynamic>>[cores],
      appBarTheme: AppBarTheme(
        backgroundColor: cores.marca,
        foregroundColor: cores.sobreMarca,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dividerTheme: DividerThemeData(color: cores.divisor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cores.fundo,
        selectedItemColor: cores.icone,
        unselectedItemColor: cores.textoSecundario,
        showUnselectedLabels: true,
        elevation: 0,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: cores.foco,
        selectionColor: cores.foco.withValues(alpha: 0.3),
        selectionHandleColor: cores.foco,
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: cores.icone,
        labelStyle: TextStyle(color: cores.textoSecundario),
        floatingLabelStyle: TextStyle(color: cores.foco),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: cores.borda),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: cores.foco, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: cores.alerta),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: cores.alerta, width: 2.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cores.marca,
          foregroundColor: cores.sobreMarca,
          disabledBackgroundColor: cores.marca.withValues(alpha: 0.6),
          disabledForegroundColor: cores.sobreMarca,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cores.destaque,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base, Color cor) {
    final corpo = GoogleFonts.interTextTheme(base).apply(
      bodyColor: cor,
      displayColor: cor,
    );

    TextStyle? titulo(TextStyle? estilo) =>
        GoogleFonts.spaceGrotesk(textStyle: estilo);

    return corpo.copyWith(
      displayLarge: titulo(corpo.displayLarge),
      displayMedium: titulo(corpo.displayMedium),
      displaySmall: titulo(corpo.displaySmall),
      headlineLarge: titulo(corpo.headlineLarge),
      headlineMedium: titulo(corpo.headlineMedium),
      headlineSmall: titulo(corpo.headlineSmall),
      titleLarge: titulo(corpo.titleLarge),
    );
  }
}
