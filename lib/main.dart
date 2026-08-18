import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC7000);
    const backgroundColor = Color(0xFFFFF7F2);

    return MaterialApp(
      title: 'Zena+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        inputDecorationTheme: const InputDecorationTheme(
          prefixIconColor: primaryColor,
          labelStyle: TextStyle(color: Color(0xFF666666)),
          floatingLabelStyle: TextStyle(color: primaryColor),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class Gasto {
  String nome;
  double preco;

  Gasto({required this.nome, required this.preco});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _salarioController = TextEditingController();
  final TextEditingController _gastosController = TextEditingController();
  final TextEditingController _nomeGastoController = TextEditingController();

  double _valorDigitadoSalario = 0.0;
  List<Gasto> gastos = [];

  @override
  void dispose() {
    _salarioController.dispose();
    _gastosController.dispose();
    _nomeGastoController.dispose();
    super.dispose();
  }

  void _processarSalario() {
    setState(() {
      String textoTratado = _salarioController.text.replaceAll(',', '.');
      _valorDigitadoSalario = double.tryParse(textoTratado) ?? 0.0;
      _salarioController.clear();
    });
  }

  void _processarGasto() {
    setState(() {
      String textoTratadoGasto = _gastosController.text.replaceAll(',', '.');
      double precoGasto = double.tryParse(textoTratadoGasto) ?? 0.0;
      String nomeGasto = _nomeGastoController.text;

      if (nomeGasto.isNotEmpty && precoGasto > 0) {
        gastos.add(Gasto(nome: nomeGasto, preco: precoGasto));
      }

      _gastosController.clear();
      _nomeGastoController.clear();
    });
  }

  double get _totalGastos => gastos.fold(0, (soma, item) => soma + item.preco);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEC7000),
        foregroundColor: Colors.white,
         title: Row(
          children: [
            Image.asset(
              'assets/zena-logo-dark-bg.png',
              height: 35,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
          child: Column(
            children: [
              CamposValoresRow(
                salarioController: _salarioController,
                gastosController: _gastosController,
                nomeGastoController: _nomeGastoController,
              ),

              const SizedBox(height: 16),

              BotoesEnviarRow(
                onEnviarSalario: _processarSalario,
                onEnviarGasto: _processarGasto,
              ),

              const SizedBox(height: 24),

              ResultadoDisplay(
                salario: _valorDigitadoSalario,
                totalGastos: _totalGastos,
                quantidadeGastos: gastos.length,
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE0E0E0)),
              const SizedBox(height: 16),

              ListaGastosDisplay(gastos: gastos),
            ],
          ),
        ),
      ),
    );
  }
}

class CamposValoresRow extends StatelessWidget {
  final TextEditingController salarioController;
  final TextEditingController gastosController;
  final TextEditingController nomeGastoController;

  const CamposValoresRow({
    super.key,
    required this.salarioController,
    required this.gastosController,
    required this.nomeGastoController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: salarioController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Salário',
              hintText: '2000.00',
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: nomeGastoController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Nome do gasto',
              hintText: 'Gasolina',
              prefixIcon: Icon(Icons.label_outline, color: Color(0xFFEC7000)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: gastosController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Preço',
              hintText: '160.00',
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
        ),
      ],
    );
  }
}

class BotoesEnviarRow extends StatelessWidget {
  final VoidCallback onEnviarSalario;
  final VoidCallback onEnviarGasto;

  const BotoesEnviarRow({
    super.key,
    required this.onEnviarSalario,
    required this.onEnviarGasto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onEnviarSalario,
            child: const Text('Salvar Salário'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onEnviarGasto,
            child: const Text('Adicionar Gasto'),
          ),
        ),
      ],
    );
  }
}

class ResultadoDisplay extends StatelessWidget {
  final double salario;
  final double totalGastos;
  final int quantidadeGastos;

  const ResultadoDisplay({
    super.key,
    required this.salario,
    required this.totalGastos,
    required this.quantidadeGastos,
  });

  @override
  Widget build(BuildContext context) {
    final saldoRestante = salario - totalGastos;

    return Column(
      children: [
        Text(
          'Salário: R\$ ${salario.toStringAsFixed(2)} | Total Gastos: R\$ ${totalGastos.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Saldo Restante: R\$ ${saldoRestante.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }
}

class ListaGastosDisplay extends StatelessWidget {
  final List<Gasto> gastos;

  const ListaGastosDisplay({super.key, required this.gastos});

  @override
  Widget build(BuildContext context) {
    if (gastos.isEmpty) {
      return const Text(
        'Nenhum gasto cadastrado.',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: gastos.length,
      itemBuilder: (context, index) {
        final gastoItem = gastos[index];

        return Card(
          color: Colors.white,
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.shopping_cart, color: Color(0xFFEC7000)),
            title: Text(gastoItem.nome),
            trailing: Text(
              'R\$ ${gastoItem.preco.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ),
        );
      },
    );
  }
}