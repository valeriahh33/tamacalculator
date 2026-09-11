import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF1DCCB);
  static const panel = Color(0xFFF5E9DF);
  static const panelLight = Color(0xFFFFF5EE);
  static const border = Color(0xFF63372F);
  static const text = Color(0xFF5C2D29);
  static const screen = Color(0xFFB9E7F5);
  static const screenShadow = Color(0xFF79BBD0);
  static const pink = Color(0xFFF083B0);
  static const pinkLight = Color(0xFFFFB7D1);
  static const mint = Color(0xFF88D9BA);
  static const purple = Color(0xFFB796E3);
  static const yellow = Color(0xFFFFD36D);
  static const orange = Color(0xFFFFB34F);
  static const red = Color(0xFFF07878);
  static const cream = Color(0xFFFFF8F0);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.pink),
      fontFamily: 'monospace',
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
