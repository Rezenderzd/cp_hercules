import 'package:flutter/material.dart';

import '../../models/gasto.dart';
import '../theme/app_colors.dart';

class FatiaOrcamento {
  final String nome;
  final double valor;
  final double percentual;
  final Color cor;

  const FatiaOrcamento({
    required this.nome,
    required this.valor,
    required this.percentual,
    required this.cor,
  });
}

class ResultadoOrcamento {
  final List<FatiaOrcamento> fatias;
  final bool orcamentoEstourado;
  final double excedente;

  const ResultadoOrcamento({
    required this.fatias,
    required this.orcamentoEstourado,
    required this.excedente,
  });

  static const vazio = ResultadoOrcamento(
    fatias: [],
    orcamentoEstourado: false,
    excedente: 0,
  );
}

ResultadoOrcamento calcularOrcamento({
  required double salario,
  required List<Gasto> gastos,
}) {
  if (salario <= 0) return ResultadoOrcamento.vazio;

  final totalGastos = gastos.fold<double>(0, (soma, g) => soma + g.preco);
  final estourado = totalGastos > salario;
  final base = estourado ? totalGastos : salario;

  final fatiasGastos = <FatiaOrcamento>[
    for (var i = 0; i < gastos.length; i++)
      FatiaOrcamento(
        nome: gastos[i].nome,
        valor: gastos[i].preco,
        percentual: base > 0 ? (gastos[i].preco / base) * 100 : 0,
        cor: AppColors.graficoPaleta[i % AppColors.graficoPaleta.length],
      ),
  ];

  if (estourado) {
    return ResultadoOrcamento(
      fatias: fatiasGastos,
      orcamentoEstourado: true,
      excedente: totalGastos - salario,
    );
  }

  final restante = salario - totalGastos;

  return ResultadoOrcamento(
    fatias: [
      ...fatiasGastos,
      FatiaOrcamento(
        nome: 'Restante',
        valor: restante,
        percentual: (restante / salario) * 100,
        cor: AppColors.sucesso,
      ),
    ],
    orcamentoEstourado: false,
    excedente: 0,
  );
}
