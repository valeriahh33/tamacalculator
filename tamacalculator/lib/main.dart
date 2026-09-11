import 'package:flutter/material.dart';

import 'layers/core/theme/app_theme.dart';
import 'layers/presentation/screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TamaCalculatorApp());
}

class TamaCalculatorApp extends StatelessWidget {
  const TamaCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TAMA-CALC',
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
