import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/calculator_controller.dart';
import '../../widgets/cat_display.dart';
import '../../widgets/pixel_border.dart';
import '../../widgets/pixel_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final CalculatorController controller;

  @override
  void initState() {
    super.initState();
    controller = CalculatorController()..addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    controller.removeListener(_refresh);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo de la app: la misma imagen del gatito
          Image.asset(
            'assets/images/fondo_gato.png',
            fit: BoxFit.cover,
          ),
          // Capa oscura sutil para que resalte el marco
          Container(color: const Color(0x33472A28)),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: _CalculatorShell(controller: controller),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorShell extends StatelessWidget {
  const _CalculatorShell({required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    return PixelBorder(
      color: AppColors.panel,
      borderColor: AppColors.border,
      borderWidth: 4,
      pixelSize: 6,
      shadowOffset: const Offset(0, 8),
      shadowColor: AppColors.borderDark,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
        child: Column(
          children: [
            const _Header(),
            const SizedBox(height: 10),
            CatDisplay(
              expression: controller.expression,
              display: controller.display,
              message: controller.message,
              messageIsError: controller.messageIsError,
              reaction: controller.reaction,
            ),
            const SizedBox(height: 10),
            _Keypad(controller: controller),
            const SizedBox(height: 6),
            // Decoración inferior: huellitas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.pets, color: AppColors.pink, size: 14),
                SizedBox(width: 8),
                Icon(Icons.pets, color: AppColors.pink, size: 14),
                SizedBox(width: 8),
                Icon(Icons.pets, color: AppColors.pink, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets, color: AppColors.pink, size: 26),
          const SizedBox(width: 8),
          const Text(
            'TAMA-CALC',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: AppColors.pink,
              shadows: [Shadow(color: AppColors.borderDark, offset: Offset(2, 2))],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.pets, color: AppColors.pink, size: 26),
        ],
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          PixelButton(label: '×', subLabel: 'MULTIPLICAR', backgroundColor: AppColors.orange, onPressed: () => controller.chooseOperation(CalculatorOperation.multiply)),
          PixelButton(label: '÷', subLabel: 'DIVISIÓN', backgroundColor: AppColors.mint, onPressed: () => controller.chooseOperation(CalculatorOperation.divide)),
          PixelButton(label: '%', subLabel: 'RESIDUO', backgroundColor: AppColors.mint, onPressed: () => controller.chooseOperation(CalculatorOperation.remainder)),
          PixelButton(label: 'PAR/', subLabel: 'IMPAR', fontSize: 13, backgroundColor: AppColors.purple, onPressed: controller.checkParity),
        ]),
        Row(children: [
          PixelButton(label: 'x²', subLabel: 'POTENCIA', fontSize: 22, backgroundColor: AppColors.yellow, onPressed: controller.square),
          PixelButton(label: '√', subLabel: 'RADICAR', fontSize: 27, backgroundColor: AppColors.mint, onPressed: controller.squareRoot),
          PixelButton(label: 'LOG₁₀', subLabel: 'LOG', fontSize: 15, backgroundColor: AppColors.purple, onPressed: controller.logarithm10),
          PixelButton(label: '÷', subLabel: 'COCIENTE', fontSize: 21, backgroundColor: AppColors.purple, onPressed: () => controller.chooseOperation(CalculatorOperation.quotient)),
        ]),
        Row(children: [
          PixelButton(label: '−', subLabel: 'RESTA', fontSize: 25, backgroundColor: AppColors.purple, onPressed: () => controller.chooseOperation(CalculatorOperation.subtract)),
          PixelButton(label: '+', subLabel: 'SUMA', fontSize: 25, backgroundColor: AppColors.orange, onPressed: () => controller.chooseOperation(CalculatorOperation.add)),
          PixelButton(label: '^', subLabel: 'POTENCIA', fontSize: 24, backgroundColor: AppColors.yellow, onPressed: () => controller.chooseOperation(CalculatorOperation.power)),
          PixelButton(label: 'C', backgroundColor: AppColors.red, onPressed: controller.clear),
        ]),
        Row(children: [
          PixelButton(label: '1', backgroundColor: AppColors.pink, onPressed: () => controller.inputDigit('1')),
          PixelButton(label: '2', backgroundColor: AppColors.mint, onPressed: () => controller.inputDigit('2')),
          PixelButton(label: '3', backgroundColor: AppColors.purple, onPressed: () => controller.inputDigit('3')),
          PixelButton(label: '4', backgroundColor: AppColors.pink, onPressed: () => controller.inputDigit('4')),
        ]),
        Row(children: [
          PixelButton(label: '5', backgroundColor: AppColors.mint, onPressed: () => controller.inputDigit('5')),
          PixelButton(label: '6', backgroundColor: AppColors.purple, onPressed: () => controller.inputDigit('6')),
          PixelButton(label: '7', backgroundColor: AppColors.orange, onPressed: () => controller.inputDigit('7')),
          PixelButton(label: '8', backgroundColor: AppColors.mint, onPressed: () => controller.inputDigit('8')),
        ]),
        Row(children: [
          PixelButton(label: '9', backgroundColor: AppColors.purple, onPressed: () => controller.inputDigit('9')),
          PixelButton(label: '0', backgroundColor: AppColors.mint, onPressed: () => controller.inputDigit('0')),
          PixelButton(label: '±', backgroundColor: AppColors.orange, fontSize: 21, onPressed: controller.toggleSign),
          PixelButton(label: '.', backgroundColor: AppColors.purple, onPressed: controller.inputDecimal),
        ]),
        Row(children: [
          PixelButton(label: '=', backgroundColor: AppColors.yellow, fontSize: 30, flex: 4, onPressed: controller.equals),
        ]),
      ],
    );
  }
}