import 'package:flutter/material.dart';

import 'app_colors.dart';

class ZenaCores extends ThemeExtension<ZenaCores> {
  const ZenaCores({
    required this.marca,
    required this.sobreMarca,
    required this.destaque,
    required this.link,
    required this.icone,
    required this.foco,
    required this.alerta,
    required this.fundo,
    required this.texto,
    required this.textoSecundario,
    required this.cartao,
    required this.borda,
    required this.divisor,
    required this.sucesso,
    required this.gasto,
  });

  final Color marca;
  final Color sobreMarca;
  final Color destaque;
  final Color link;
  final Color icone;
  final Color foco;
  final Color alerta;
  final Color fundo;
  final Color texto;
  final Color textoSecundario;
  final Color cartao;
  final Color borda;
  final Color divisor;
  final Color sucesso;
  final Color gasto;

  static const ZenaCores claro = ZenaCores(
    marca: AppColors.laranja,
    sobreMarca: Colors.white,
    destaque: AppColors.laranja,
    link: AppColors.laranja,
    icone: AppColors.laranja,
    foco: AppColors.laranja,
    alerta: AppColors.vermelho,
    fundo: AppColors.creme,
    texto: AppColors.claroTexto,
    textoSecundario: AppColors.claroTextoSecundario,
    cartao: AppColors.claroCartao,
    borda: AppColors.claroBorda,
    divisor: AppColors.claroDivisor,
    sucesso: AppColors.sucesso,
    gasto: AppColors.gasto,
  );

  static const ZenaCores noturno = ZenaCores(
    marca: AppColors.vermelho,
    sobreMarca: AppColors.creme,
    destaque: AppColors.laranja,
    link: AppColors.vermelho,
    icone: AppColors.vermelho,
    foco: AppColors.vermelho,
    alerta: AppColors.noturnoGasto,
    fundo: AppColors.grafite,
    texto: AppColors.creme,
    textoSecundario: AppColors.noturnoTextoSecundario,
    cartao: AppColors.noturnoCartao,
    borda: AppColors.noturnoBorda,
    divisor: AppColors.noturnoDivisor,
    sucesso: AppColors.sucesso,
    gasto: AppColors.noturnoGasto,
  );

  @override
  ZenaCores copyWith({
    Color? marca,
    Color? sobreMarca,
    Color? destaque,
    Color? link,
    Color? icone,
    Color? foco,
    Color? alerta,
    Color? fundo,
    Color? texto,
    Color? textoSecundario,
    Color? cartao,
    Color? borda,
    Color? divisor,
    Color? sucesso,
    Color? gasto,
  }) {
    return ZenaCores(
      marca: marca ?? this.marca,
      sobreMarca: sobreMarca ?? this.sobreMarca,
      destaque: destaque ?? this.destaque,
      link: link ?? this.link,
      icone: icone ?? this.icone,
      foco: foco ?? this.foco,
      alerta: alerta ?? this.alerta,
      fundo: fundo ?? this.fundo,
      texto: texto ?? this.texto,
      textoSecundario: textoSecundario ?? this.textoSecundario,
      cartao: cartao ?? this.cartao,
      borda: borda ?? this.borda,
      divisor: divisor ?? this.divisor,
      sucesso: sucesso ?? this.sucesso,
      gasto: gasto ?? this.gasto,
    );
  }

  @override
  ZenaCores lerp(ThemeExtension<ZenaCores>? other, double t) {
    if (other is! ZenaCores) return this;
    return ZenaCores(
      marca: Color.lerp(marca, other.marca, t)!,
      sobreMarca: Color.lerp(sobreMarca, other.sobreMarca, t)!,
      destaque: Color.lerp(destaque, other.destaque, t)!,
      link: Color.lerp(link, other.link, t)!,
      icone: Color.lerp(icone, other.icone, t)!,
      foco: Color.lerp(foco, other.foco, t)!,
      alerta: Color.lerp(alerta, other.alerta, t)!,
      fundo: Color.lerp(fundo, other.fundo, t)!,
      texto: Color.lerp(texto, other.texto, t)!,
      textoSecundario: Color.lerp(textoSecundario, other.textoSecundario, t)!,
      cartao: Color.lerp(cartao, other.cartao, t)!,
      borda: Color.lerp(borda, other.borda, t)!,
      divisor: Color.lerp(divisor, other.divisor, t)!,
      sucesso: Color.lerp(sucesso, other.sucesso, t)!,
      gasto: Color.lerp(gasto, other.gasto, t)!,
    );
  }
}

extension ZenaContext on BuildContext {
  ZenaCores get zena => Theme.of(this).extension<ZenaCores>() ?? ZenaCores.claro;
}
