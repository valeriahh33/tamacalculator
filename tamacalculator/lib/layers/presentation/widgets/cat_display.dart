import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'pixel_border.dart';

class CatDisplay extends StatelessWidget {
  const CatDisplay({
    super.key,
    required this.expression,
    required this.display,
    required this.message,
    required this.messageIsError,
    required this.reaction,
  });

  final String expression;
  final String display;
  final String? message;
  final bool messageIsError;
  final String reaction;

  @override
  Widget build(BuildContext context) {
    return PixelBorder(
      color: AppColors.screen,
      borderColor: AppColors.border,
      borderWidth: 3,
      pixelSize: 4,
      shadowOffset: const Offset(0, 6),
      shadowColor: AppColors.borderDark,
      child: SizedBox(
        height: 210,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Fondo de la habitación
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset('assets/images/fondo_gato.png', fit: BoxFit.cover),
              ),
            ),

            // Gato en el centro
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Image.asset('assets/images/gato.png', height: 130, fit: BoxFit.contain),
              ),
            ),

            // 🔹 Burbuja de reacción JUSTO ENCIMA DE LA CABEZA DEL GATO
            // El gato está centrado y su cabeza queda ~a 40px del top.
            Positioned(
              top: 4,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: _EmojiBubble(emoji: reaction),
              ),
            ),

            // Huellitas decorativas
            const Positioned(
              top: 12,
              left: 12,
              child: Icon(Icons.pets, color: AppColors.pink, size: 16),
            ),
            const Positioned(
              bottom: 75,
              left: 20,
              child: Icon(Icons.auto_awesome, color: AppColors.sparkle, size: 14),
            ),
            const Positioned(
              bottom: 85,
              right: 25,
              child: Icon(Icons.auto_awesome, color: AppColors.sparkle, size: 10),
            ),

            // Pantalla de resultado superpuesta
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFB3E5FC),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
                  border: Border(top: BorderSide(color: AppColors.border, width: 3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (expression.isNotEmpty)
                      Text(
                        expression,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF4D747C)),
                      ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        display,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: message == null ? 30 : 20,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    if (message != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          message!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: messageIsError ? const Color(0xFF9E3D3D) : AppColors.text,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmojiBubble extends StatelessWidget {
  const _EmojiBubble({required this.emoji});

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PixelBorder(
          color: AppColors.cream,
          borderColor: AppColors.border,
          borderWidth: 2,
          pixelSize: 3,
          shadowOffset: const Offset(0, 3),
          shadowColor: AppColors.borderDark,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
        ),
        // Colita de la burbuja apuntando hacia abajo (hacia el gato)
        CustomPaint(
          size: const Size(12, 8),
          painter: _BubbleTailPainter(),
        ),
      ],
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.cream;
    final borderPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}