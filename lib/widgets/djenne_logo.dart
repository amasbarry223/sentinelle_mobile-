import 'package:flutter/material.dart';

class DjenneLogo extends StatelessWidget {
  final double size;
  final bool showBadgeBorder;

  const DjenneLogo({
    super.key,
    this.size = 140,
    this.showBadgeBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if asset is reloading
          return Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF166534),
            ),
            child: Icon(
              Icons.shield_rounded,
              color: const Color(0xFFC88A28),
              size: size * 0.55,
            ),
          );
        },
      ),
    );
  }
}
