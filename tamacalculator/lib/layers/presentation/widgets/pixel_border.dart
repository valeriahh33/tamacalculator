import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PixelBorder extends StatelessWidget {
  const PixelBorder({
    super.key,
    required this.child,
    this.color = AppColors.panel,
    this.borderColor = AppColors.border,
    this.borderWidth = 3.0,
    this.pixelSize = 4.0,
    this.shadowOffset = const Offset(0, 5),
    this.shadowColor = AppColors.borderDark,
  });

  final Widget child;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double pixelSize;
  final Offset shadowOffset;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PixelBorderPainter(
        color: color,
        borderColor: borderColor,
        borderWidth: borderWidth,
        pixelSize: pixelSize,
        shadowOffset: shadowOffset,
        shadowColor: shadowColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth + pixelSize),
        child: child,
      ),
    );
  }
}

class _PixelBorderPainter extends CustomPainter {
  _PixelBorderPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.pixelSize,
    required this.shadowOffset,
    required this.shadowColor,
  });

  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double pixelSize;
  final Offset shadowOffset;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final shadowPaint = Paint()..color = shadowColor;
    final borderPaint = Paint()..color = borderColor;
    final fillPaint = Paint()..color = color;

    final p = pixelSize;
    final b = borderWidth;

    // Sombra (desplazada)
    _drawPixelShape(
      canvas,
      size,
      shadowPaint,
      p,
      b,
      shadowOffset,
    );

    // Borde
    _drawPixelShape(canvas, size, borderPaint, p, b, Offset.zero);

    // Relleno interior (más pequeño)
    final innerOffset = Offset(b, b);
    final innerSize = Size(size.width - b * 2, size.height - b * 2);
    _drawPixelShape(
      canvas,
      innerSize,
      fillPaint,
      p,
      b,
      innerOffset,
      isInner: true,
    );
  }

  void _drawPixelShape(
    Canvas canvas,
    Size size,
    Paint paint,
    double p,
    double b,
    Offset offset, {
    bool isInner = false,
  }) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Empezamos en la esquina superior izquierda, con el "corte" pixelado
    path.moveTo(offset.dx + p, offset.dy);
    path.lineTo(offset.dx + w - p, offset.dy);
    path.lineTo(offset.dx + w - p, offset.dy + p);
    path.lineTo(offset.dx + w, offset.dy + p);
    path.lineTo(offset.dx + w, offset.dy + h - p);
    path.lineTo(offset.dx + w - p, offset.dy + h - p);
    path.lineTo(offset.dx + w - p, offset.dy + h);
    path.lineTo(offset.dx + p, offset.dy + h);
    path.lineTo(offset.dx + p, offset.dy + h - p);
    path.lineTo(offset.dx, offset.dy + h - p);
    path.lineTo(offset.dx, offset.dy + p);
    path.lineTo(offset.dx + p, offset.dy + p);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PixelBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.pixelSize != pixelSize ||
        oldDelegate.shadowOffset != shadowOffset ||
        oldDelegate.shadowColor != shadowColor;
  }
}