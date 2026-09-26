import '../models/investimento.dart';

const List<Investimento> investimentosMock = [
  Investimento(
    id: 'poupanca',
    nome: 'Poupança',
    descricao: 'Dinheiro disponível na hora, mas rende pouco.',
    rentabilidadeAnual: 6.5,
    risco: RiscoInvestimento.baixo,
    chanceDeErroPct: 1,
    perdaSeErrarPct: 2,
  ),
  Investimento(
    id: 'tesouro-selic',
    nome: 'Tesouro Selic',
    descricao: 'Você empresta ao governo. Comum para reserva de emergência.',
    rentabilidadeAnual: 10.5,
    risco: RiscoInvestimento.baixo,
    chanceDeErroPct: 2,
    perdaSeErrarPct: 5,
  ),
  Investimento(
    id: 'cdb',
    nome: 'CDB de banco grande',
    descricao: 'Você empresta ao banco e recebe juros por isso.',
    rentabilidadeAnual: 11.2,
    risco: RiscoInvestimento.baixo,
    chanceDeErroPct: 3,
    perdaSeErrarPct: 8,
  ),

  Investimento(
    id: 'fii',
    nome: 'Fundos imobiliários',
    descricao: 'Cotas de fundos que investem em imóveis e pagam aluguéis.',
    rentabilidadeAnual: 13.8,
    risco: RiscoInvestimento.medio,
    chanceDeErroPct: 12,
    perdaSeErrarPct: 25,
  ),
  Investimento(
    id: 'credito-privado',
    nome: 'Fundo de crédito privado',
    descricao: 'Empresta a empresas: rende mais, mas pode haver calote.',
    rentabilidadeAnual: 14.5,
    risco: RiscoInvestimento.medio,
    chanceDeErroPct: 15,
    perdaSeErrarPct: 30,
  ),

  Investimento(
    id: 'acoes',
    nome: 'Ações',
    descricao: 'Você vira sócio de empresas na bolsa. O preço oscila muito.',
    rentabilidadeAnual: 19.0,
    risco: RiscoInvestimento.alto,
    chanceDeErroPct: 30,
    perdaSeErrarPct: 50,
  ),
  Investimento(
    id: 'cripto',
    nome: 'Criptomoedas',
    descricao: 'Ativos digitais muito voláteis, com grande chance de queda.',
    rentabilidadeAnual: 32.0,
    risco: RiscoInvestimento.alto,
    chanceDeErroPct: 45,
    perdaSeErrarPct: 70,
  ),
];
