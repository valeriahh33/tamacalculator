import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFFCE4EC);
  static const panel = Color(0xFFFFF0F5);
  static const panelLight = Color(0xFFFFF5EE);
  static const border = Color(0xFF5D4037);
  static const borderDark = Color(0xFF3E2723);
  static const text = Color(0xFF4E342E);
  static const screen = Color(0xFFB3E5FC);
  static const screenShadow = Color(0xFF81D4FA);
  static const pink = Color(0xFFF48FB1);
  static const pinkLight = Color(0xFFFFB7D1);
  static const mint = Color(0xFF80CBC4);
  static const purple = Color(0xFFCE93D8);
  static const yellow = Color(0xFFFFE082);
  static const orange = Color(0xFFFFCC80);
  static const red = Color(0xFFEF9A9A);
  static const cream = Color(0xFFFFF8F0);
  static const sparkle = Color(0xFFFFF9C4);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent, // Fondo transparente para ver la imagen
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.pink),
      fontFamily: 'monospace',
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}