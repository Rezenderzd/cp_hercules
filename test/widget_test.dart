import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cp4_hercules/app.dart';
import 'package:cp4_hercules/core/theme/app_colors.dart';
import 'package:cp4_hercules/core/theme/app_theme.dart';
import 'package:cp4_hercules/core/theme/theme_controller.dart';
import 'package:cp4_hercules/core/theme/zena_cores.dart';
import 'package:cp4_hercules/models/gasto.dart';
import 'package:cp4_hercules/services/financas_repository.dart';
import 'package:cp4_hercules/services/mock_auth_service.dart';
import 'package:cp4_hercules/services/mock_financas_repository.dart';
import 'package:cp4_hercules/widgets/boas_vindas_header.dart';
import 'package:cp4_hercules/widgets/lista_gastos_display.dart';

class _RepositorioComFalha extends MockFinancasRepository {
  bool falhar = true;

  @override
  Future<List<Gasto>> listarGastos() async {
    if (falhar) {
      throw const FinancasFalha('As tabelas não foram encontradas.');
    }
    return super.listarGastos();
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget criarApp({
    FinancasRepository? repositorio,
    ThemeMode modo = ThemeMode.light,
  }) {
    return ZenaApp(
      authService: MockAuthService(latencia: Duration.zero),
      financasRepository: repositorio ?? MockFinancasRepository(),
      themeController: ThemeController(modoInicial: modo),
    );
  }

  void usarTelaGrande(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> entrarComoAna(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).at(0), 'ana@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
  }

  testWidgets('Login mostra erros quando o formulário está vazio',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());

    expect(find.text('Bem-vindo de volta'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pump();

    expect(find.text('Digite seu e-mail.'), findsOneWidget);
    expect(find.text('Digite sua senha.'), findsOneWidget);
  });

  testWidgets('Login mock leva para a Home', (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());

    await entrarComoAna(tester);

    expect(find.text('Salvar Salário'), findsOneWidget);
    expect(find.text('Bem-vindo de volta'), findsNothing);
  });

  testWidgets('Home recebe a pessoa pelo nome (vindo do e-mail)',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());

    await entrarComoAna(tester);

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('Recepção usa saudação do horário e só o primeiro nome',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: BoasVindasHeader(
            nome: 'fernando caires silva',
            agora: DateTime(2026, 9, 19, 9),
          ),
        ),
      ),
    );

    expect(find.text('Bom dia,'), findsOneWidget);
    expect(find.text('Fernando'), findsOneWidget);
    expect(find.text('F'), findsOneWidget);
  });

  testWidgets('Botão da Home alterna entre modo claro e noturno',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());
    await entrarComoAna(tester);

    ThemeData temaAtual() =>
        Theme.of(tester.element(find.text('Salvar Salário')));

    expect(temaAtual().brightness, Brightness.light);
    expect(temaAtual().scaffoldBackgroundColor, AppColors.creme);

    await tester.tap(find.byTooltip('Modo noturno'));
    await tester.pumpAndSettle();

    expect(temaAtual().brightness, Brightness.dark);
    expect(temaAtual().scaffoldBackgroundColor, AppColors.grafite);
    expect(temaAtual().colorScheme.primary, AppColors.vermelho);

    await tester.tap(find.byTooltip('Modo claro'));
    await tester.pumpAndSettle();

    expect(temaAtual().brightness, Brightness.light);
    expect(temaAtual().colorScheme.primary, AppColors.laranja);
  });

  test('Tema noturno troca laranja por vermelho e branco por grafite', () {
    final claro = AppTheme.light.extension<ZenaCores>()!;
    final noturno = AppTheme.dark.extension<ZenaCores>()!;

    expect(claro.marca, AppColors.laranja);
    expect(noturno.marca, AppColors.vermelho);
    expect(claro.fundo, AppColors.creme);
    expect(noturno.fundo, AppColors.grafite);
    expect(noturno.texto, AppColors.creme);
  });

  test('Inputs e ícones acompanham o tema: laranja no claro, vermelho no noturno',
      () {
    final claro = AppTheme.light;
    expect(claro.extension<ZenaCores>()!.icone, AppColors.laranja);
    expect(claro.inputDecorationTheme.prefixIconColor, AppColors.laranja);
    expect(claro.inputDecorationTheme.floatingLabelStyle?.color, AppColors.laranja);
    expect(claro.inputDecorationTheme.focusedBorder?.borderSide.color, AppColors.laranja);
    expect(claro.textSelectionTheme.cursorColor, AppColors.laranja);

    final noturno = AppTheme.dark;
    expect(noturno.extension<ZenaCores>()!.icone, AppColors.vermelho);
    expect(noturno.inputDecorationTheme.prefixIconColor, AppColors.vermelho);
    expect(noturno.inputDecorationTheme.floatingLabelStyle?.color, AppColors.vermelho);
    expect(noturno.inputDecorationTheme.focusedBorder?.borderSide.color, AppColors.vermelho);
    expect(noturno.textSelectionTheme.cursorColor, AppColors.vermelho);
  });

  test('Link de login/cadastro acompanha o tema; demais botões de texto ficam laranja',
      () {
    expect(AppTheme.light.extension<ZenaCores>()!.link, AppColors.laranja);
    expect(AppTheme.dark.extension<ZenaCores>()!.link, AppColors.vermelho);

    expect(AppTheme.light.extension<ZenaCores>()!.destaque, AppColors.laranja);
    expect(AppTheme.dark.extension<ZenaCores>()!.destaque, AppColors.laranja);
  });

  testWidgets('Link "Criar conta" é laranja no claro e vermelho no noturno',
      (WidgetTester tester) async {
    usarTelaGrande(tester);

    Future<Color?> corDoLink(ThemeMode modo) async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(criarApp(modo: modo));
      await tester.pumpAndSettle();

      final botao = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Criar conta'),
      );
      return botao.style?.foregroundColor?.resolve(<WidgetState>{});
    }

    expect(await corDoLink(ThemeMode.light), AppColors.laranja);
    expect(await corDoLink(ThemeMode.dark), AppColors.vermelho);
  });

  testWidgets('Ícone da lista de gastos acompanha o tema (laranja/vermelho)',
      (WidgetTester tester) async {
    Future<Color?> corDoIcone(ThemeData tema) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: tema,
          home: const Scaffold(
            body: ListaGastosDisplay(
              gastos: [Gasto(id: '1', nome: 'Gasolina', preco: 100)],
            ),
          ),
        ),
      );
      return tester.widget<Icon>(find.byIcon(Icons.shopping_cart)).color;
    }

    expect(await corDoIcone(AppTheme.light), AppColors.laranja);
    expect(await corDoIcone(AppTheme.dark), AppColors.vermelho);
  });

  testWidgets('Cadastro leva direto para a Home, sem pedir confirmação por e-mail',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());

    await tester.tap(find.widgetWithText(TextButton, 'Criar conta'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Ana');
    await tester.enterText(find.byType(TextFormField).at(1), 'ana@email.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.enterText(find.byType(TextFormField).at(3), '123456');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Criar conta'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    expect(find.text('Salvar Salário'), findsOneWidget);
    expect(find.text('Crie sua conta'), findsNothing);
    expect(find.textContaining('confirma'), findsNothing);
  });

  testWidgets('Cadastro avisa quando as senhas não são iguais',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());

    await tester.tap(find.widgetWithText(TextButton, 'Criar conta'));
    await tester.pumpAndSettle();

    expect(find.text('Crie sua conta'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Ana');
    await tester.enterText(find.byType(TextFormField).at(1), 'ana@email.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.enterText(find.byType(TextFormField).at(3), '654321');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Criar conta'));
    await tester.pump();

    expect(find.text('As senhas não são iguais.'), findsOneWidget);
  });

  testWidgets('Home: salva o salário e cria, edita e exclui um gasto',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());
    await entrarComoAna(tester);

    await tester.enterText(find.widgetWithText(TextField, 'Salário'), '2000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar Salário'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Salário: R\$ 2000.00'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextField, 'Nome do gasto'), 'Gasolina');
    await tester.enterText(find.widgetWithText(TextField, 'Preço'), '100');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Adicionar Gasto'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Gasolina'), findsOneWidget);
    expect(find.text('R\$ 100.00'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Gasolina'));
    await tester.pumpAndSettle();
    expect(find.text('Editar gasto'), findsOneWidget);

    final camposDoDialogo = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(camposDoDialogo.at(1), '80,50');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('R\$ 80.50'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Gasolina'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Excluir'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum gasto cadastrado.'), findsOneWidget);
  });

  testWidgets('Home avisa quando o gasto está incompleto',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());
    await entrarComoAna(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Adicionar Gasto'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text('Informe o nome do gasto e um preço maior que zero.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(ListTile, 'Gasolina'), findsNothing);
  });

  testWidgets('Home mostra o erro de carga e permite tentar de novo',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    final repositorio = _RepositorioComFalha();
    await tester.pumpWidget(criarApp(repositorio: repositorio));
    await entrarComoAna(tester);

    expect(find.text('As tabelas não foram encontradas.'), findsOneWidget);

    repositorio.falhar = false;
    await tester.tap(find.text('Tentar de novo'));
    await tester.pumpAndSettle();

    expect(find.text('As tabelas não foram encontradas.'), findsNothing);
    expect(find.text('Nenhum gasto cadastrado.'), findsOneWidget);
  });

  testWidgets('Barra de abas troca entre Início e Investimentos',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());
    await entrarComoAna(tester);

    int abaSelecionada() =>
        tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar)).currentIndex;

    expect(abaSelecionada(), 0);
    expect(find.text('Salvar Salário'), findsOneWidget);

    await tester.tap(find.text('Investimentos'));
    await tester.pumpAndSettle();
    expect(abaSelecionada(), 1);
    expect(find.text('Quanto você quer investir?'), findsOneWidget);
    expect(find.text('Salvar Salário'), findsNothing);

    await tester.enterText(find.byType(TextField), '2000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Simular'));
    await tester.pumpAndSettle();
    expect(find.text('+ R\$ 210,00'), findsOneWidget);

    await tester.tap(find.text('Início'));
    await tester.pumpAndSettle();
    expect(abaSelecionada(), 0);
    expect(find.text('Salvar Salário'), findsOneWidget);
  });

  testWidgets('Aba Painel mostra o salário e os gastos como fatias do gráfico',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());
    await entrarComoAna(tester);

    await tester.enterText(find.widgetWithText(TextField, 'Salário'), '2000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar Salário'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, 'Nome do gasto'), 'Aluguel');
    await tester.enterText(find.widgetWithText(TextField, 'Preço'), '500');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Adicionar Gasto'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Painel'));
    await tester.pumpAndSettle();

    expect(find.text('Salário: R\$ 2.000,00'), findsOneWidget);
    expect(find.text('Aluguel'), findsOneWidget);
    expect(find.text('25,00%'), findsOneWidget);
    expect(find.text('Restante'), findsOneWidget);
    expect(find.text('75,00%'), findsOneWidget);
  });

  testWidgets('Painel avisa quando o salário ainda não foi informado',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());
    await entrarComoAna(tester);

    await tester.tap(find.text('Painel'));
    await tester.pumpAndSettle();

    expect(
      find.text('Informe o seu salário na aba Início para ver o painel.'),
      findsOneWidget,
    );
  });

  testWidgets('Painel avisa quando os gastos ultrapassam o salário',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());
    await entrarComoAna(tester);

    await tester.enterText(find.widgetWithText(TextField, 'Salário'), '1000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar Salário'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, 'Nome do gasto'), 'Viagem');
    await tester.enterText(find.widgetWithText(TextField, 'Preço'), '1500');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Adicionar Gasto'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Painel'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('a mais que o salário'),
      findsOneWidget,
    );
    expect(find.text('Restante'), findsNothing);
  });

  testWidgets('Sair leva de volta ao login', (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());
    await entrarComoAna(tester);

    await tester.tap(find.byTooltip('Sair'));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo de volta'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsNothing);
  });

  testWidgets('Modo noturno disponível no login e no cadastro',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());

    ThemeData temaDe(String textoNaTela) =>
        Theme.of(tester.element(find.text(textoNaTela)));

    expect(temaDe('Bem-vindo de volta').brightness, Brightness.light);
    await tester.tap(find.byTooltip('Modo noturno'));
    await tester.pumpAndSettle();
    expect(temaDe('Bem-vindo de volta').brightness, Brightness.dark);

    await tester.tap(find.widgetWithText(TextButton, 'Criar conta'));
    await tester.pumpAndSettle();
    expect(temaDe('Crie sua conta').brightness, Brightness.dark);

    await tester.tap(find.byTooltip('Modo claro'));
    await tester.pumpAndSettle();
    expect(temaDe('Crie sua conta').brightness, Brightness.light);
  });

  testWidgets('Modo noturno disponível na página de investimentos',
      (WidgetTester tester) async {
    usarTelaGrande(tester);
    await tester.pumpWidget(criarApp());
    await entrarComoAna(tester);

    await tester.tap(find.text('Investimentos'));
    await tester.pumpAndSettle();

    ThemeData temaAtual() =>
        Theme.of(tester.element(find.text('Quanto você quer investir?')));

    expect(temaAtual().brightness, Brightness.light);
    await tester.tap(find.byTooltip('Modo noturno'));
    await tester.pumpAndSettle();
    expect(temaAtual().brightness, Brightness.dark);
    expect(temaAtual().scaffoldBackgroundColor, AppColors.grafite);
  });
}
