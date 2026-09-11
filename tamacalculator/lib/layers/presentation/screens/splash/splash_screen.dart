import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../calculator/calculator_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
    _timer = Timer(const Duration(milliseconds: 2300), _openCalculator);
  }

  void _openCalculator() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const CalculatorScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/fondo_gato.png', fit: BoxFit.cover),
          Container(color: const Color(0x66472A28)),
          SafeArea(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => FadeTransition(
                opacity: CurvedAnimation(parent: _animation, curve: Curves.easeOut),
                child: ScaleTransition(
                  scale: Tween<double>(begin: .78, end: 1).animate(
                    CurvedAnimation(parent: _animation, curve: Curves.elasticOut),
                  ),
                  child: child,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 250,
                        height: 310,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.panel,
                          border: Border.all(color: AppColors.border, width: 4),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [
                            BoxShadow(color: AppColors.border, blurRadius: 0, offset: Offset(7, 8)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset('assets/images/fondo_gato.png', fit: BoxFit.cover),
                              Container(color: const Color(0x33FFF5EE)),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset('assets/images/gato.png', height: 205, fit: BoxFit.contain),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'TAMA-CALC',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: AppColors.panelLight,
                          shadows: const [Shadow(color: AppColors.border, offset: Offset(3, 3))],
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        '¡CÁLCULO DIVERTIDO!',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppColors.panelLight),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: 170,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (_, __) => LinearProgressIndicator(
                              minHeight: 10,
                              value: _animation.value,
                              backgroundColor: AppColors.panelLight,
                              valueColor: const AlwaysStoppedAnimation(AppColors.pink),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
