import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../controllers/calculator_controller.dart';
import '../../widgets/cat_display.dart';
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 18),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: _CalculatorShell(controller: controller),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CalculatorShell extends StatelessWidget {
  const _CalculatorShell({required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 14),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: AppColors.border, width: 3),
        borderRadius: BorderRadius.circular(38),
        boxShadow: const [BoxShadow(color: AppColors.border, blurRadius: 0, offset: Offset(0, 8))],
      ),
      child: Column(
        children: [
          const _Header(),
          CatDisplay(
            expression: controller.expression,
            display: controller.display,
            message: controller.message,
            messageIsError: controller.messageIsError,
          ),
          const SizedBox(height: 8),
          _Keypad(controller: controller),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Row(
        children: [
          _HeaderIcon(icon: '×', fill: AppColors.screen),
          const Spacer(),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Calculadora', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.text)),
              Text('TAMA-CALC', style: TextStyle(fontSize: 22, height: 1, fontWeight: FontWeight.w900, letterSpacing: 1, color: AppColors.pink)),
            ],
          ),
          const Spacer(),
          _HeaderIcon(icon: '▤', fill: AppColors.yellow),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.fill});

  final String icon;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27,
      height: 27,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill.withOpacity(.45),
        border: Border.all(color: AppColors.border, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(icon, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.text)),
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
          PixelButton(label: '=', backgroundColor: AppColors.mint, fontSize: 30, flex: 4, onPressed: controller.equals),
        ]),
      ],
    );
  }
}
