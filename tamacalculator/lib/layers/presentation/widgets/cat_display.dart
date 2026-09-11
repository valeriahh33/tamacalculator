import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class CatDisplay extends StatelessWidget {
  const CatDisplay({
    super.key,
    required this.expression,
    required this.display,
    required this.message,
    required this.messageIsError,
  });

  final String expression;
  final String display;
  final String? message;
  final bool messageIsError;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.screen,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.border, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.border, blurRadius: 0, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 148,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/fondo_gato.png', fit: BoxFit.cover),
                  Container(color: AppColors.screen.withOpacity(.30)),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Image.asset('assets/images/gato.png', height: 122, fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 9,
                    child: _TinyBadge(label: '123'),
                  ),
                  Positioned(
                    top: 9,
                    left: 10,
                    child: _TinyBadge(label: '♥'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            decoration: const BoxDecoration(
              color: Color(0xFFA5D5E4),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(21)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
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
                      fontSize: message == null ? 30 : 21,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: AppColors.text,
                    ),
                  ),
                ),
                if (message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
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
        ],
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.cream,
        border: Border.all(color: AppColors.border, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.text)),
    );
  }
}
