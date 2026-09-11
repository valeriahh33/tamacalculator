import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PixelButton extends StatefulWidget {
  const PixelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.subLabel,
    this.backgroundColor = AppColors.pink,
    this.fontSize = 22,
    this.flex = 1,
    this.icon, // Para el botón de = o retroceder
  });

  final String label;
  final String? subLabel;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double fontSize;
  final int flex;
  final IconData? icon;

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTapDown: (_) => setState(() => pressed = true),
          onTapCancel: () => setState(() => pressed = false),
          onTapUp: (_) {
            setState(() => pressed = false);
            widget.onPressed();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 70),
            transform: Matrix4.translationValues(0, pressed ? 4 : 0, 0),
            height: 60, // Altura fija para mantener la cuadrícula
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              border: Border.all(color: AppColors.border, width: 3),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.border,
                  blurRadius: 0,
                  offset: Offset(0, pressed ? 0 : 5),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.icon != null)
                  Icon(widget.icon, color: AppColors.text, size: 28)
                else
                  Padding(
                    padding: EdgeInsets.only(bottom: widget.subLabel == null ? 0 : 8),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                if (widget.subLabel != null)
                  Positioned(
                    bottom: 6,
                    child: Text(
                      widget.subLabel!,
                      style: const TextStyle(
                        fontSize: 7,
                        height: 1,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}