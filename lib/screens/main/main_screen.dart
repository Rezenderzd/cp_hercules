import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/theme/zena_cores.dart';
import '../../services/auth_service.dart';
import '../../services/financas_repository.dart';
import '../../widgets/botao_tema.dart';
import '../dashboard/dashboard_screen.dart';
import '../home/home_screen.dart';
import '../investimentos/investimentos_screen.dart';

class MainScreen extends StatefulWidget {
  final AuthService authService;
  final FinancasRepository financasRepository;
  final ThemeController themeController;

  const MainScreen({
    super.key,
    required this.authService,
    required this.financasRepository,
    required this.themeController,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    HomeScreen(
      authService: widget.authService,
      financasRepository: widget.financasRepository,
    ),
    const InvestimentosScreen(),
    DashboardScreen(financasRepository: widget.financasRepository),
  ];

  Future<void> _sair() async {
    try {
      await widget.authService.sair();
    } on AuthFalha catch (falha) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(falha.mensagem)),
      );
      return;
    }
    widget.financasRepository.limpar();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (rota) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/zena-logo-dark-bg.png',
              height: 35,
            ),
            const SizedBox(width: 10),
          ],
        ),
        actions: [
          BotaoTema(controller: widget.themeController),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _sair,
          ),
        ],
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.zena.divisor)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Investimentos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Painel',
            ),
          ],
        ),
      ),
    );
  }
}
