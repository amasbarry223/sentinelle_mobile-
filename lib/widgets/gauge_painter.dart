import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GaugeWidget extends StatelessWidget {
  final int score; // 0 to 100
  final double size;

  const GaugeWidget({
    super.key,
    required this.score,
    this.size = 220,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: score.toDouble()),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return SizedBox(
          width: size,
          height: size * 0.65,
          child: CustomPaint(
            painter: _GaugePainter(score: animatedValue),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;

  _GaugePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.88);
    final radius = size.width * 0.42;
    const strokeWidth = 18.0;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final segments = [
      _Segment(0.0, 0.32, const Color(0xFF5DBB89)),
      _Segment(0.32, 0.65, const Color(0xFFF6C25B)),
      _Segment(0.65, 0.82, const Color(0xFFF09885)),
      _Segment(0.82, 1.0, const Color(0xFFDC2626)),
    ];

    for (final seg in segments) {
      final start = math.pi + (seg.startRatio * math.pi);
      final sweep = (seg.endRatio - seg.startRatio) * math.pi;

      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = (seg.startRatio == 0.0 || seg.endRatio == 1.0)
            ? StrokeCap.round
            : StrokeCap.butt;

      canvas.drawArc(rect, start, sweep, false, paint);
    }

    // Number marks: 0, 50, 100
    final markStyle = GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF71717A),
    );

    // Mark 0
    _drawText(canvas, Offset(center.dx - radius - 14, center.dy - 4), "0", markStyle);
    // Mark 50
    _drawText(canvas, Offset(center.dx - 7, center.dy - radius - 20), "50", markStyle);
    // Mark 100
    _drawText(canvas, Offset(center.dx + radius + 4, center.dy - 4), "100", markStyle);

    // Needle calculation
    final clampedScore = score.clamp(0.0, 100.0);
    final angle = math.pi + (clampedScore / 100.0) * math.pi;
    final needleLength = radius * 0.82;

    final needleTarget = Offset(
      center.dx + needleLength * math.cos(angle),
      center.dy + needleLength * math.sin(angle),
    );

    // Needle pivot circle
    final pivotPaint = Paint()
      ..color = const Color(0xFF1F2937)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 9, pivotPaint);

    final needlePaint = Paint()
      ..color = const Color(0xFF1F2937)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleTarget, needlePaint);

    // Center big score text
    final scorePainter = TextPainter(
      text: TextSpan(
        text: clampedScore.toInt().toString(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 38,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF1E1E1E),
          letterSpacing: -1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    scorePainter.paint(
      canvas,
      Offset(center.dx - scorePainter.width / 2, center.dy - 50),
    );

    // "/ 100" text
    final subPainter = TextPainter(
      text: TextSpan(
        text: "/ 100",
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF71717A),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    subPainter.paint(
      canvas,
      Offset(center.dx - subPainter.width / 2, center.dy - 14),
    );
  }

  void _drawText(Canvas canvas, Offset offset, String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.score != score;
}

class _Segment {
  final double startRatio;
  final double endRatio;
  final Color color;

  _Segment(this.startRatio, this.endRatio, this.color);
}
