import 'dart:math' as math;
import 'package:flutter/material.dart';

class OnboardingIllustration extends StatelessWidget {
  final int step; // 0, 1, 2, 3
  final double size;

  const OnboardingIllustration({
    super.key,
    required this.step,
    this.size = 240,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _OnboardingPainter(step: step),
      ),
    );
  }
}

class _OnboardingPainter extends CustomPainter {
  final int step;

  _OnboardingPainter({required this.step});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bgRadius = size.width * 0.42;

    // Warm cream circle background
    final bgPaint = Paint()
      ..color = const Color(0xFFF7ECD8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, bgRadius, bgPaint);

    // Decorative floating dots
    final dotGreen = Paint()..color = const Color(0xFF86EFAC);
    final dotOchre = Paint()..color = const Color(0xFFFDE68A);

    canvas.drawCircle(Offset(center.dx - bgRadius * 0.9, center.dy - bgRadius * 0.2), 6, dotGreen);
    canvas.drawCircle(Offset(center.dx + bgRadius * 0.85, center.dy + bgRadius * 0.3), 5, dotOchre);
    canvas.drawCircle(Offset(center.dx + bgRadius * 0.7, center.dy - bgRadius * 0.6), 4, dotGreen);

    switch (step) {
      case 0:
        _drawStep0(canvas, center, size);
        break;
      case 1:
        _drawStep1(canvas, center, size);
        break;
      case 2:
        _drawStep2(canvas, center, size);
        break;
      case 3:
        _drawStep3(canvas, center, size);
        break;
    }
  }

  // Step 0: Scam phone + exclamation badge + person
  void _drawStep0(Canvas canvas, Offset center, Size size) {
    // Malian person figure on the left
    final personPaint = Paint()..color = const Color(0xFF166534);
    final skinPaint = Paint()..color = const Color(0xFF8D5B28);
    final capPaint = Paint()..color = const Color(0xFFC88A28);

    final personCenter = Offset(center.dx - size.width * 0.25, center.dy + size.height * 0.05);

    // Body (trapezoid boubou)
    final path = Path()
      ..moveTo(personCenter.dx - 28, personCenter.dy + 45)
      ..lineTo(personCenter.dx - 12, personCenter.dy - 12)
      ..lineTo(personCenter.dx + 12, personCenter.dy - 12)
      ..lineTo(personCenter.dx + 28, personCenter.dy + 45)
      ..close();
    canvas.drawPath(path, personPaint);

    // Head
    canvas.drawCircle(Offset(personCenter.dx, personCenter.dy - 28), 16, skinPaint);
    // Cap (chéchia)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(personCenter.dx, personCenter.dy - 32), radius: 17),
      math.pi,
      math.pi,
      true,
      capPaint,
    );

    // Smartphone on right
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + size.width * 0.16, center.dy + size.height * 0.02),
        width: size.width * 0.32,
        height: size.height * 0.54,
      ),
      const Radius.circular(16),
    );

    // Phone outline
    canvas.drawRRect(
      phoneRect,
      Paint()
        ..color = const Color(0xFF14532D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
    canvas.drawRRect(phoneRect, Paint()..color = Colors.white);

    // Alert box inside phone
    final alertBox = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + size.width * 0.16, center.dy + size.height * 0.02),
        width: size.width * 0.22,
        height: size.height * 0.12,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(alertBox, Paint()..color = const Color(0xFFFEE2E2));
    canvas.drawRRect(
      alertBox,
      Paint()
        ..color = const Color(0xFFEF4444)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Exclamation speech bubble badge on top right of phone
    final badgeCenter = Offset(center.dx + size.width * 0.35, center.dy - size.height * 0.22);
    canvas.drawCircle(badgeCenter, 18, Paint()..color = const Color(0xFFDC2626));
    final bubblePath = Path()
      ..moveTo(badgeCenter.dx - 8, badgeCenter.dy + 12)
      ..lineTo(badgeCenter.dx - 14, badgeCenter.dy + 24)
      ..lineTo(badgeCenter.dx + 4, badgeCenter.dy + 16)
      ..close();
    canvas.drawPath(bubblePath, Paint()..color = const Color(0xFFDC2626));

    // Exclamation mark
    final textPainter = TextPainter(
      text: const TextSpan(
        text: "!",
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(badgeCenter.dx - textPainter.width / 2, badgeCenter.dy - 14));
  }

  // Step 1: Magnifying glass + Shield
  void _drawStep1(Canvas canvas, Offset center, Size size) {
    // Document bubble
    final docRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - size.width * 0.06, center.dy - size.height * 0.05),
        width: size.width * 0.50,
        height: size.height * 0.34,
      ),
      const Radius.circular(16),
    );
    canvas.drawRRect(docRect, Paint()..color = Colors.white);
    canvas.drawRRect(
      docRect,
      Paint()
        ..color = const Color(0xFFE2E8F0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Text lines inside doc
    final linePaint = Paint()
      ..color = const Color(0xFFD97706)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    canvas.drawLine(
      Offset(docRect.left + 16, docRect.top + 28),
      Offset(docRect.right - 40, docRect.top + 28),
      linePaint,
    );
    canvas.drawLine(
      Offset(docRect.left + 16, docRect.top + 46),
      Offset(docRect.right - 60, docRect.top + 46),
      linePaint..strokeWidth = 5,
    );

    // Green Shield
    final shieldCenter = Offset(center.dx + size.width * 0.18, center.dy - size.height * 0.02);
    final shieldPath = Path()
      ..moveTo(shieldCenter.dx - 24, shieldCenter.dy - 28)
      ..lineTo(shieldCenter.dx + 24, shieldCenter.dy - 28)
      ..lineTo(shieldCenter.dx + 24, shieldCenter.dy)
      ..quadraticBezierTo(shieldCenter.dx + 24, shieldCenter.dy + 36, shieldCenter.dx, shieldCenter.dy + 46)
      ..quadraticBezierTo(shieldCenter.dx - 24, shieldCenter.dy + 36, shieldCenter.dx - 24, shieldCenter.dy)
      ..close();
    canvas.drawPath(shieldPath, Paint()..color = const Color(0xFF166534));

    // Checkmark inside shield
    final checkPath = Path()
      ..moveTo(shieldCenter.dx - 10, shieldCenter.dy + 4)
      ..lineTo(shieldCenter.dx - 2, shieldCenter.dy + 12)
      ..lineTo(shieldCenter.dx + 12, shieldCenter.dy - 8);
    canvas.drawPath(
      checkPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round,
    );

    // Magnifying glass
    final glassCenter = Offset(center.dx - size.width * 0.10, center.dy + size.height * 0.12);
    canvas.drawCircle(
      glassCenter,
      30,
      Paint()
        ..color = const Color(0xFFC88A28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9,
    );
    canvas.drawCircle(glassCenter, 24, Paint()..color = Colors.white.withValues(alpha: 0.4));

    // Handle
    canvas.drawLine(
      Offset(glassCenter.dx + 22, glassCenter.dy + 22),
      Offset(glassCenter.dx + 46, glassCenter.dy + 46),
      Paint()
        ..color = const Color(0xFFC88A28)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10,
    );
  }

  // Step 2: Phone with padlock inside + local loop arrow
  void _drawStep2(Canvas canvas, Offset center, Size size) {
    // Phone
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + size.height * 0.02),
        width: size.width * 0.36,
        height: size.height * 0.58,
      ),
      const Radius.circular(18),
    );
    canvas.drawRRect(phoneRect, Paint()..color = Colors.white);
    canvas.drawRRect(
      phoneRect,
      Paint()
        ..color = const Color(0xFF166534)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.5,
    );

    // Padlock inside phone
    final lockCenter = Offset(center.dx, center.dy + size.height * 0.08);

    // Lock shackle (gold)
    final shackleRect = Rect.fromCenter(
      center: Offset(lockCenter.dx, lockCenter.dy - 18),
      width: 28,
      height: 34,
    );
    canvas.drawArc(
      shackleRect,
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFFC88A28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    // Lock body (green)
    final lockBody = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: lockCenter,
        width: 44,
        height: 38,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(lockBody, Paint()..color = const Color(0xFF166534));

    // Keyhole
    canvas.drawCircle(Offset(lockCenter.dx, lockCenter.dy - 2), 4, Paint()..color = Colors.white);
    canvas.drawLine(
      Offset(lockCenter.dx, lockCenter.dy - 2),
      Offset(lockCenter.dx, lockCenter.dy + 6),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Red barred arrow (nothing leaks out)
    final arrowStart = Offset(center.dx + size.width * 0.20, center.dy - size.height * 0.14);
    final arrowEnd = Offset(center.dx + size.width * 0.36, center.dy - size.height * 0.02);
    canvas.drawLine(
      arrowStart,
      arrowEnd,
      Paint()
        ..color = const Color(0xFFDC2626)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    // Arrow head
    canvas.drawLine(
      arrowEnd,
      Offset(arrowEnd.dx - 10, arrowEnd.dy - 12),
      Paint()
        ..color = const Color(0xFFDC2626)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      arrowEnd,
      Offset(arrowEnd.dx - 14, arrowEnd.dy + 2),
      Paint()
        ..color = const Color(0xFFDC2626)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  // Step 3: Malian community + sound wave
  void _drawStep3(Canvas canvas, Offset center, Size size) {
    // 3 figures
    _drawPerson(canvas, Offset(center.dx - 38, center.dy + 22), const Color(0xFF166534), const Color(0xFF8D5B28), const Color(0xFFC88A28));
    _drawPerson(canvas, Offset(center.dx + 38, center.dy + 24), const Color(0xFF166534), const Color(0xFF5A3919), const Color(0xFFD97706));
    _drawPerson(canvas, Offset(center.dx, center.dy + 12), const Color(0xFFD97706), const Color(0xFF714922), const Color(0xFF14532D));

    // Shields on outer left and right
    final shieldLeft = Offset(center.dx - size.width * 0.34, center.dy + size.height * 0.12);
    _drawMiniShield(canvas, shieldLeft, const Color(0xFFC88A28));

    final shieldRight = Offset(center.dx + size.width * 0.34, center.dy + size.height * 0.12);
    _drawMiniShield(canvas, shieldRight, const Color(0xFF166534));

    // Bambara Audio Wave Bubble at top center
    final bubbleCenter = Offset(center.dx - size.width * 0.06, center.dy - size.height * 0.22);
    canvas.drawCircle(bubbleCenter, 20, Paint()..color = Colors.white);
    canvas.drawCircle(
      bubbleCenter,
      20,
      Paint()
        ..color = const Color(0xFFE2E8F0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Audio sound bars
    final barPaint = Paint()
      ..color = const Color(0xFF166534)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(bubbleCenter.dx - 6, bubbleCenter.dy - 5), Offset(bubbleCenter.dx - 6, bubbleCenter.dy + 5), barPaint);
    canvas.drawLine(Offset(bubbleCenter.dx, bubbleCenter.dy - 9), Offset(bubbleCenter.dx, bubbleCenter.dy + 9), barPaint);
    canvas.drawLine(Offset(bubbleCenter.dx + 6, bubbleCenter.dy - 4), Offset(bubbleCenter.dx + 6, bubbleCenter.dy + 4), barPaint);
  }

  void _drawPerson(Canvas canvas, Offset pCenter, Color boubouColor, Color skinColor, Color capColor) {
    // Body
    final path = Path()
      ..moveTo(pCenter.dx - 22, pCenter.dy + 36)
      ..lineTo(pCenter.dx - 10, pCenter.dy - 8)
      ..lineTo(pCenter.dx + 10, pCenter.dy - 8)
      ..lineTo(pCenter.dx + 22, pCenter.dy + 36)
      ..close();
    canvas.drawPath(path, Paint()..color = boubouColor);

    // Head
    canvas.drawCircle(Offset(pCenter.dx, pCenter.dy - 20), 12, Paint()..color = skinColor);
    // Traditional Malian cap
    canvas.drawArc(
      Rect.fromCircle(center: Offset(pCenter.dx, pCenter.dy - 22), radius: 13),
      math.pi,
      math.pi,
      true,
      Paint()..color = capColor,
    );
  }

  void _drawMiniShield(Canvas canvas, Offset sCenter, Color color) {
    final path = Path()
      ..moveTo(sCenter.dx - 12, sCenter.dy - 14)
      ..lineTo(sCenter.dx + 12, sCenter.dy - 14)
      ..lineTo(sCenter.dx + 12, sCenter.dy)
      ..quadraticBezierTo(sCenter.dx + 12, sCenter.dy + 18, sCenter.dx, sCenter.dy + 24)
      ..quadraticBezierTo(sCenter.dx - 12, sCenter.dy + 18, sCenter.dx - 12, sCenter.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
