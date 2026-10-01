# Zena+

Organização financeira para a Geração Z.

Projeto integrado dos Checkpoints 4, 5 e 6 da disciplina **Desenvolvimento de Aplicações Multiplataforma** (FIAP · Ciência da Computação · 2º ano), com o Prof. Hercules Ramos.

## Proposta de valor

Zena+ começa como o Pierre (CloudWalk): conecta a vida financeira do usuário e organiza tudo automaticamente, sem planilha e sem exigir que a pessoa vire "analista financeira de si mesma". A diferença é o horizonte — enquanto os apps de hoje param no controle do gasto do mês, o Zena+ ajuda a Geração Z a transformar a disciplina que ela já tem no dia a dia em decisões que constroem o futuro: reserva, metas, patrimônio, aposentadoria.

## O problema

Dados recentes mostram um contraste importante na nossa geração:

- Segundo o **Mapa da Inadimplência do Serasa (maio/2026)**, jovens de 18 a 25 anos representam apenas **11% dos inadimplentes do país**, a menor participação entre todas as faixas etárias (contra 33,3% na faixa 26-40 e 35,7% na faixa 41-60).
- Segundo o estudo **Raio X do Investidor Brasileiro 2026** (Anbima + Datafolha), apenas **12% da Geração Z** já iniciou uma reserva para aposentadoria, embora **66%** afirmem que pretendem começar no futuro.
- Um levantamento do setor (ClienteSA) aponta que **55%** da Geração Z se considera financeiramente organizada, o maior índice entre as gerações, mas **73%** sente que suas conquistas financeiras estão atrasadas em relação às próprias metas, e **42%** diz que o dinheiro afeta diretamente a saúde mental.

Ou seja: somos a geração mais disciplinada no controle do dia a dia, mas sem estrutura nenhuma para pensar em longo prazo, e isso já pesa na cabeça de quem vive essa realidade.

## Público-alvo

- Jovens de aproximadamente **18 a 25 anos**, majoritariamente universitários ou em início de carreira
- Já usam banco digital e Pix no dia a dia, alguns têm cartão de crédito e pagam em dia
- Nunca fizeram um investimento de longo prazo ou não sabem por onde começar
- Querem organização sem esforço manual (não gostam de planilha, não têm paciência pra apps cheios de gráfico)
- Valorizam marcas com linguagem direta e que não os tratem como "irresponsáveis"

## Marca

- **Nome:** Zena+ mantém o "Z" como referência direta à Geração Z, e o "+" reforça a proposta central da marca: depois de organizar o básico, sempre tem um próximo passo (guardar, investir, crescer). O nome soa como um nome próprio curto, no mesmo espírito humanizado da concorrência, o que facilita a construção de um tom de voz mais pessoal e menos corporativo.
- **Tom de voz:** direto, acolhedor, confiável, motivador (sem julgamento sobre erros passados)
- Exemplos de uso:
  - "Notamos R$ 90 em assinaturas que você não usa há 2 meses. Quer revisar?"
  - "Faltam R$ 340 pra você bater sua meta de reserva do mês. Ainda dá tempo."

## Identidade visual

- **Paleta:** laranja Itaú (`#EC7000`) como cor primária + vermelho Bradesco (`#CC092F`) como acento, com neutros quentes (`#241A15` / `#FFF7F2`)
- **Tipografia:** Space Grotesk (títulos e números em destaque) + Inter (interface, tabelas, corpo) — ambas gratuitas via Google Fonts / pacote `google_fonts` no Flutter
- **Logo:** ícone de porquinho (cofrinho) + wordmark "Zena+", arquivos finais:
  - `zena-logo-dark-bg.png` (porquinho e wordmark em creme, para fundos laranja/escuros, usado no cabeçalho do app)
  - `zena-logo-light-bg.png` (porquinho em laranja e wordmark em grafite, para fundos brancos/claros, README, apresentação)
  - `zena-logo-icon.png` (ícone quadrado com fundo laranja e porquinho em creme, para o launcher do app)
- Board de ideias completo (referências, paleta, tom de voz, nome, tipografia): [ver no Figma](https://www.figma.com/board/SDKAwifTkTvITRMQaGuYjY)

## Pitch — por que o Zena+ existiria no mercado

**Diferencial competitivo:** o Pierre e os apps de organização financeira param no controle do gasto do mês. Apps tradicionais de planilha (Mobills, Organizze) exigem esforço manual de categorização. O Zena+ ocupa o espaço entre os dois: a mesma simplicidade de uso do Pierre, mas com o olhar de longo prazo que nenhum dos dois oferece hoje, construído por quem já trabalha dentro do mercado financeiro e conhece as dores reais desse público.

**Modelo de negócio (proposto):**
- **Freemium** — organização básica (cadastro manual, depois conexão via Open Finance, alertas simples) gratuita
- **Assinatura premium** — funcionalidades avançadas (simulação de aposentadoria, metas múltiplas, relatórios aprofundados)
- **Parcerias financeiras (fase futura)** — comissionamento por indicação de produtos de investimento/reserva dentro do app, aproveitando a experiência do grupo no setor bancário para validar parceiros confiáveis

## Integrantes do grupo e papéis

| RM | Nome | Papel no projeto |
| --- | --- | --- |
| 563415 | Fernando Caires Silva | Pitch |
| 563500 | Guilherme Martins Rezende | Código |
| 563567 | Raphael Mischiatti de Souza | Marca e identidade visual |

## Status do projeto

| Checkpoint | Foco | Status |
| --- | --- | --- |
| CP4 | Idealização do app (marca, identidade visual, pitch, projeto inicial) | Concluído |
| CP5 | Protótipo funcional (telas navegáveis, banco de dados, ambiente de teste) | **Entrega atual** |
| CP6 | App final (MVP completo e APK instalável) | Próxima etapa |

## Vídeo de demonstração

[![Vídeo de demonstração do Zena+](https://img.youtube.com/vi/cQdzXCkEB3s/hqdefault.jpg)](https://youtu.be/cQdzXCkEB3s)

▶️ **[Assistir no YouTube](https://youtu.be/cQdzXCkEB3s)**

## Imagens do app

> Salve os prints na pasta `imagens/cp5/` com os nomes abaixo para que apareçam aqui.

| Login | Cadastro |
| --- | --- |
| <img src="imagens/cp5/login.png" alt="Tela de login" width="240" /> | <img src="imagens/cp5/cadastro.png" alt="Tela de cadastro" width="240" /> |

| Início (modo claro) | Início (modo noturno) |
| --- | --- |
| <img src="imagens/cp5/inicio-claro.png" alt="Aba Início no modo claro" width="240" /> | <img src="imagens/cp5/inicio-noturno.png" alt="Aba Início no modo noturno" width="240" /> |

| Investimentos | Painel |
| --- | --- |
| <img src="imagens/cp5/investimentos.png" alt="Aba Investimentos com uma simulação" width="240" /> | <img src="imagens/cp5/painel.png" alt="Aba Painel com os gráficos" width="240" /> |

| Banco de dados no Supabase |
| --- |
| <img src="imagens/cp5/supabase-tabelas.png" alt="Tabelas do projeto no Supabase" width="480" /> |

## O que mudou do CP4 para o CP5

| Aspecto | CP4 | CP5 |
| --- | --- | --- |
| Telas | Uma tela única | Login, cadastro e três abas: Início, Investimentos e Painel |
| Navegação | Nenhuma | Rotas nomeadas + barra de abas inferior (`BottomNavigationBar`) |
| Conta do usuário | Não existia | Login e cadastro com e-mail e senha (Supabase Auth) |
| Onde os dados ficam | Na memória (somem ao fechar o app) | Banco de dados PostgreSQL no Supabase, separado por usuário |
| Gastos | Só adicionar e listar | Adicionar, listar, editar e excluir |
| Período dos gastos | Sem controle de data | Cada gasto é registrado no mês em que foi criado; a tela Início mostra só o mês atual |
| Salário | Um valor solto | Salvo no banco, com histórico mês a mês |
| Gráficos | Nenhum | Painel com "Gastos por mês" e "Patrimônio por mês" |
| Investimentos | Não existia | Simulador com rentabilidade, retorno em R$ e nível de risco |
| Identidade visual | Cores aplicadas, fonte padrão | Paleta e tipografia do CP4 aplicadas (Space Grotesk + Inter), modo noturno e saudação personalizada |
| Código | Tudo em um único `main.dart` | Organizado em `core/`, `models/`, `services/`, `screens/` e `widgets/` |
| Credenciais | Não se aplicava | URL e chave do Supabase em arquivo `.env`, fora do Git |
| Testes | Teste padrão do Flutter | Testes automatizados das regras de negócio e das telas |

## Funcionalidades do protótipo (CP5)

**Login e cadastro**
- Cadastro com nome, e-mail, senha e confirmação de senha, com validação dos campos.
- Login com e-mail e senha, verificado pelo Supabase Auth.
- Como o app é acadêmico, o cadastro não exige confirmação por e-mail: a pessoa entra direto no app.
- Mensagens de erro em português (senha incorreta, e-mail já cadastrado, muitas tentativas etc.).

**Aba Início**
- Recepção no estilo dos apps de banco: "Bom dia / Boa tarde / Boa noite" + o primeiro nome do usuário.
- Cadastro do salário e dos gastos (nome + preço).
- Saldo restante calculado automaticamente (salário − gastos do mês).
- Lista dos gastos do mês atual. Tocando em um gasto, é possível editar ou excluir.
- No dia 1º de cada mês, a lista recomeça do zero. Os gastos antigos não são apagados: continuam no banco e aparecem no histórico do Painel.

**Aba Investimentos**
- O usuário informa quanto quer investir e toca em **Simular**.
- Sete opções, do menor para o maior risco, cada uma com rentabilidade anual, retorno em R$ em 12 meses, etiqueta de risco (baixo, médio ou alto), chance de dar errado e perda possível no pior cenário.
- Regra do produto: quanto maior o risco, maior o retorno e maior a chance de dar errado.

**Aba Painel**
- **Gastos por mês:** gráfico de colunas com o total gasto em cada um dos últimos 6 meses. A coluna do mês atual muda conforme gastos são adicionados, editados ou excluídos; os meses anteriores ficam fixos.
- **Patrimônio por mês:** gráfico de colunas em verde com o salário de cada mês, mostrando aumento ou queda em relação ao mês anterior. O mês atual usa o salário atual do usuário; cada mês passado guarda o último valor salvo nele.
- Os dados reais começam no mês em que o usuário criou a conta. Os meses anteriores mostram valores de exemplo, para o gráfico já ter histórico desde o primeiro acesso.

**Em todas as telas**
- Botão para alternar entre modo claro e modo noturno.
- Botão de sair da conta.

## Dados reais x dados mockados

O app tem apenas dois conjuntos de dados mockados, ambos na pasta `lib/data/`:

| Dados mockados | Arquivo | O que são |
| --- | --- | --- |
| Opções de investimento | `investimentos_mock.dart` | Rentabilidades, chances de erro e perdas ilustrativas das sete opções. Não representam recomendação de investimento. |
| Histórico antes da criação da conta | `historico_mock.dart` | Nos gráficos do Painel, os meses anteriores ao mês em que o usuário criou a conta mostram valores de exemplo, iguais para todo usuário (ex.: R$ 500 de gastos em agosto e R$ 2.000 de patrimônio em junho). O próprio gráfico avisa quando um mês é de exemplo. |

Todo o resto usa dados reais, gravados no Supabase: contas de usuário, nome, salário, gastos e o histórico a partir do mês de criação da conta.

> Se o arquivo `.env` não estiver preenchido, o app abre em modo de demonstração: o login aceita qualquer e-mail e senha, e o salário e os gastos ficam só na memória até o app ser fechado. Esse modo não traz dados prontos; ele existe apenas para o app não travar sem backend. Na avaliação, o app roda com o Supabase configurado.

## Como rodar o projeto

**Pré-requisitos**
- Flutter instalado (Dart 3.12 ou superior), com VS Code ou Android Studio.
- Google Chrome **ou** um emulador Android configurado no Android Studio.
- Uma conta gratuita no [Supabase](https://supabase.com).

**1. Baixar o projeto**
```bash
git clone https://github.com/Rezenderzd/cp_hercules.git
cd cp_hercules
```

**2. Criar o arquivo `.env`**

Na raiz do projeto (na mesma pasta do `pubspec.yaml`), crie um arquivo chamado `.env` com o conteúdo abaixo, trocando pelos dados do seu projeto no Supabase (Project Settings → API Keys):

```
SUPABASE_URL=https://SEU-PROJECT-ID.supabase.co
SUPABASE_ANON_KEY=sb_publishable_xxxxxxxx
```

- O nome do arquivo é só `.env`, sem nada antes do ponto.
- Use apenas a chave **publishable** (pública). A chave secreta nunca vai no app.
- O `.env` já está no `.gitignore` e não deve ir para o GitHub, porque contém as suas chaves.

**3. Preparar o banco no Supabase**
- No **SQL Editor**, rode o script `supabase/zena_supabase_setup.sql` (cria as tabelas, as regras de segurança e o gatilho do cadastro).
- Em **Authentication → Sign In / Providers → Email**, deixe o provedor de e-mail **ligado** e o **Confirm email desligado**.

**4. Instalar as dependências**
```bash
flutter pub get
```

**5. Rodar**
```bash
flutter run -d chrome
```
Ou abra o emulador no Android Studio e rode `flutter run`.

Depois de editar o `.env`, reinicie o app com **hot restart** (tecla `R` maiúscula). O hot reload não recarrega o `.env`.

**6. Rodar os testes (opcional)**
```bash
flutter test
```

**Problemas comuns**
- *"The asset file '.env' doesn't exist"*: o passo 2 não foi feito.
- *"Building with plugins requires symlink support"* (Windows): ative o Modo de Desenvolvedor do Windows.
- *"Muitas tentativas"*: limite de requisições do Supabase. Espere alguns minutos ou aumente o limite em Authentication → Rate Limits.

## Banco de dados (Supabase)

E-mail e senha ficam na tabela interna do Supabase Auth (`auth.users`), com a senha guardada como hash, nunca em texto puro. As tabelas do app são:

| Tabela | Colunas | Para que serve |
| --- | --- | --- |
| `profiles` | `id`, `nome`, `salario`, `created_at` | Um registro por usuário, com o nome e o salário atual. Criado automaticamente no cadastro. |
| `gastos` | `id`, `user_id`, `nome`, `preco`, `created_at` | Cada gasto do usuário. A data `created_at` define em qual mês ele entra. |
| `salarios_mensais` | `id`, `user_id`, `mes`, `valor`, `atualizado_em` | Histórico do salário, um registro por usuário por mês. Salvar de novo no mesmo mês atualiza o registro em vez de duplicar. |

Todas as tabelas usam **RLS** (Row Level Security): cada usuário só enxerga e altera os próprios dados.

## Estrutura de pastas

```
cp_hercules/
├── assets/                       logo usado dentro do app
├── imagens/                      imagens do README
│   └── cp5/                      prints do app
├── supabase/
│   └── zena_supabase_setup.sql   criação das tabelas e regras do banco
├── lib/
│   ├── main.dart                 carrega o .env, inicia o Supabase e abre o app
│   ├── app.dart                  MaterialApp, temas e rotas
│   ├── env.dart                  leitura das chaves do .env
│   ├── core/
│   │   ├── routes.dart           nomes das rotas
│   │   ├── theme/                cores, tipografia, tema claro/noturno
│   │   └── utils/                validações, moeda, saudação, cálculos por mês
│   ├── data/
│   │   ├── investimentos_mock.dart   opções de investimento (mockadas)
│   │   └── historico_mock.dart       meses antes da criação da conta nos gráficos (mockados)
│   ├── models/                   Gasto, Investimento, SalarioMensal
│   ├── services/                 contratos e implementações (Supabase e modo demonstração)
│   ├── screens/
│   │   ├── login/                login e cadastro
│   │   ├── main/                 tela com a barra de abas
│   │   ├── home/                 aba Início
│   │   ├── investimentos/        aba Investimentos
│   │   └── dashboard/            aba Painel
│   └── widgets/                  componentes reutilizáveis (botões, campos, cards, gráficos)
├── test/                         testes automatizados
├── pubspec.yaml                  dependências do projeto
└── .env                          chaves do Supabase (só na sua máquina, fora do Git)
```

## Tecnologias utilizadas

| Tecnologia | Uso no projeto |
| --- | --- |
| **Flutter + Dart** | Framework e linguagem do app (Android, web e desktop com o mesmo código) |
| **Supabase** | Backend: autenticação (Supabase Auth) e banco de dados PostgreSQL com RLS |
| `supabase_flutter` | Cliente oficial do Supabase no app (login, cadastro e CRUD) |
| `flutter_dotenv` | Leitura das chaves do arquivo `.env` |
| `fl_chart` | Gráficos de colunas do Painel |
| `google_fonts` | Fontes da identidade visual (Space Grotesk e Inter) |
| `cupertino_icons` | Ícones padrão do Flutter |
| `flutter_test` e `flutter_lints` | Testes automatizados e verificação de boas práticas |
| **Figma** | Board de identidade visual e planejamento |
| **VS Code / Android Studio** | Desenvolvimento e emulador Android |
| **GitHub** | Versionamento e entrega |

## Decisões técnicas tomadas desde o CP4

- **Supabase como banco de dados.** PostgreSQL relacional, autenticação pronta e segurança por usuário (RLS), o que encaixa com salário e gastos separados por pessoa.
- **Chaves no `.env` com `flutter_dotenv`**, como na Aula 18, para não deixar credenciais no código nem no GitHub.
- **Telas que não conhecem o banco.** As telas usam os contratos `AuthService` e `FinancasRepository`; o Supabase é uma implementação desses contratos. Trocar de banco não exige mudar nenhuma tela (inversão de dependência, o "D" do SOLID).
- **Navegação por abas** com `BottomNavigationBar`, seguindo o Guia Prático "Do Figma ao Código Flutter", e rotas nomeadas para login, cadastro e área logada.
- **Design system centralizado.** Cores e tipografia do CP4 em `core/theme/`, com `ThemeData` e `ThemeExtension` (Aula 17). O modo noturno troca o laranja pelo vermelho da paleta e o fundo creme pelo grafite.
- **Estado sem pacote extra.** A troca de tema usa `ChangeNotifier` + `ListenableBuilder`, nativos do Flutter.
- **"Reset" mensal sem apagar dados.** Os gastos não são excluídos no dia 1º: o app filtra pelo mês de criação. Assim o histórico do Painel continua completo.
- **Histórico de salário com um registro por mês**, gravado junto com o salário atual sempre que o usuário salva o valor.
- **Cadastro sem confirmação por e-mail**, por se tratar de um projeto acadêmico.
- **Erros visíveis na tela**, com mensagens que dizem o que fazer, e o erro técnico completo no console para depuração.

## Testes automatizados

Os testes em `test/` cobrem as regras de negócio sem precisar abrir o app: validação dos formulários, saudação e nome, agrupamento de gastos por mês (incluindo a virada do ano), histórico de salário, cálculos dos investimentos e os fluxos das telas (login, cadastro, abas, edição de gastos e modo noturno). Para rodar: `flutter test`.

## Visão de longo prazo (Roadmap)

| Etapa | Situação |
| --- | --- |
| Conexão via Open Finance (importar contas e cartões automaticamente) | Planejado. No CP5 os gastos ainda são cadastrados manualmente. |
| Categorização automática de gastos | Planejado |
| Alertas inteligentes (assinaturas esquecidas, gasto fora do padrão) | Planejado |
| Metas de reserva e objetivos de longo prazo | Planejado |
| Simulação "eu no futuro" | Primeiro passo no CP5: simulador de investimentos e histórico de patrimônio no Painel |

> Este roadmap é revisado a cada Checkpoint conforme o grupo decide o que entra no MVP do CP6.
