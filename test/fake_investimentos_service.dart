import 'package:cp4_hercules/models/investimento.dart';
import 'package:cp4_hercules/services/investimentos_service.dart';

const investimentosDeTeste = [
  Investimento(
    id: 'poupanca',
    nome: 'Poupança',
    descricao: 'Dinheiro disponível na hora.',
    tipo: TipoInvestimento.rendaFixa,
    rentabilidadePct: 6.17,
    risco: RiscoInvestimento.baixo,
    chanceDePrejuizoPct: 0,
    maiorQuedaPct: 0,
    garantia: 'Garantida pelo FGC até R\$ 250 mil por CPF, por instituição.',
    fonte: 'Banco Central: Selic e TR de 16/09/2026',
  ),
  Investimento(
    id: 'tesouro-selic',
    nome: 'Tesouro Selic',
    descricao: 'Título público que acompanha a taxa Selic.',
    tipo: TipoInvestimento.rendaFixa,
    rentabilidadePct: 10.5,
    risco: RiscoInvestimento.baixo,
    chanceDePrejuizoPct: 0,
    maiorQuedaPct: 0,
    garantia: 'Garantido pelo Tesouro Nacional.',
    fonte: 'Banco Central: meta da Selic de 16/09/2026',
  ),
  Investimento(
    id: 'cdb',
    nome: 'CDB 100% do CDI',
    descricao: 'Você empresta ao banco e recebe 100% do CDI.',
    tipo: TipoInvestimento.rendaFixa,
    rentabilidadePct: 11.2,
    risco: RiscoInvestimento.baixo,
    chanceDePrejuizoPct: 0,
    maiorQuedaPct: 0,
    garantia: 'Garantido pelo FGC até R\$ 250 mil por CPF, por instituição.',
    fonte: 'Banco Central: CDI de 16/09/2026',
  ),
  Investimento(
    id: 'itub4',
    nome: 'Itaú Unibanco (ITUB4)',
    descricao: 'Ação do Itaú.',
    tipo: TipoInvestimento.acao,
    rentabilidadePct: 19,
    risco: RiscoInvestimento.alto,
    chanceDePrejuizoPct: 30,
    maiorQuedaPct: 25,
    fonte: 'brapi.dev: 248 pregões dos últimos 12 meses',
  ),
  Investimento(
    id: 'bbdc4',
    nome: 'Bradesco (BBDC4)',
    descricao: 'Ação do Bradesco.',
    tipo: TipoInvestimento.acao,
    rentabilidadePct: -32,
    risco: RiscoInvestimento.alto,
    chanceDePrejuizoPct: 85,
    maiorQuedaPct: 48,
    fonte: 'Yahoo Finance: 248 pregões dos últimos 12 meses',
  ),
];

class FakeInvestimentosService implements InvestimentosService {
  FakeInvestimentosService({
    this.opcoes = investimentosDeTeste,
    this.fontesComFalha = const [],
  });

  List<Investimento> opcoes;
  List<String> fontesComFalha;
  int chamadas = 0;

  @override
  Future<ResultadoInvestimentos> buscarOpcoes() async {
    chamadas++;
    return ResultadoInvestimentos(opcoes: opcoes, fontesComFalha: fontesComFalha);
  }
}
