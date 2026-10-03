import 'package:flutter/material.dart';

class BackgroundPattern extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color? patternColor;

  const BackgroundPattern({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFFFBF9F4),
    this.patternColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: CustomPaint(
        painter: _GeometricDiamondPatternPainter(
          lineColor: patternColor ?? const Color(0xFFEBE5DA).withValues(alpha: 0.65),
        ),
        child: child,
      ),
    );
  }
}

class _GeometricDiamondPatternPainter extends CustomPainter {
  final Color lineColor;

  _GeometricDiamondPatternPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const step = 40.0;

    // Draw diagonal grid forming concentric diamonds
    for (double x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
