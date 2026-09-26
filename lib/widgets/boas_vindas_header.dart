import 'package:flutter/material.dart';

import '../core/theme/zena_cores.dart';
import '../core/utils/nome_utils.dart';
import '../core/utils/saudacao.dart';

class BoasVindasHeader extends StatelessWidget {
  final String? nome;
  final DateTime? agora;

  const BoasVindasHeader({super.key, this.nome, this.agora});

  @override
  Widget build(BuildContext context) {
    final cores = context.zena;
    final textTheme = Theme.of(context).textTheme;

    final primeiro = primeiroNome(nome);
    final saudacaoTexto = saudacao(agora);

    return Container(
      width: double.infinity,
      color: cores.marca,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: cores.sobreMarca,
            child: primeiro != null
                ? Text(
                    primeiro[0].toUpperCase(),
                    style: textTheme.titleLarge?.copyWith(
                      color: cores.marca,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Icon(Icons.person, color: cores.marca),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: primeiro == null
                  ? [
                      Text(
                        saudacaoTexto,
                        style: textTheme.headlineSmall?.copyWith(
                          color: cores.sobreMarca,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ]
                  : [
                      Text(
                        '$saudacaoTexto,',
                        style: textTheme.bodyMedium?.copyWith(
                          color: cores.sobreMarca.withValues(alpha: 0.85),
                        ),
                      ),
                      Text(
                        primeiro,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineSmall?.copyWith(
                          color: cores.sobreMarca,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
