import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class PixelButton extends StatefulWidget {
  const PixelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.subLabel,
    this.backgroundColor = AppColors.pink,
    this.fontSize = 25,
    this.flex = 1,
  });

  final String label;
  final String? subLabel;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double fontSize;
  final int flex;

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
        padding: const EdgeInsets.all(3.5),
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
            height: widget.subLabel == null ? 57 : 58,
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
                    bottom: 5,
                    child: Text(
                      widget.subLabel!,
                      style: const TextStyle(
                        fontSize: 8,
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
