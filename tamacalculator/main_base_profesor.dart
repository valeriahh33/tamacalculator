import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sumadora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SumadoraApp(),
    );
  }
}

class SumadoraApp extends StatefulWidget {
  const SumadoraApp();

  @override
  State<SumadoraApp> createState() => _SumadoraAppState();
}

class _SumadoraAppState extends State<SumadoraApp> {
  // Variables para guardar los números
  TextEditingController numero1 = TextEditingController();
  TextEditingController numero2 = TextEditingController();
  String resultado = '';

  // Función para sumar
  void sumar() {
    try {
      int n1 = int.parse(numero1.text);
      int n2 = int.parse(numero2.text);
      int suma = n1 + n2;
      
      setState(() {
        resultado = '$n1 + $n2 = $suma';
      });
    } catch (e) {
      setState(() {
        resultado = 'Error: ingresa números válidos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sumadora'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo 1
            TextField(
              controller: numero1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo 2
            TextField(
              controller: numero2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Botón sumar
            ElevatedButton(
              onPressed: sumar,
              child: const Text('Sumar'),
            ),
            const SizedBox(height: 24),

            // Mostrar resultado
            Text(
              resultado,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}