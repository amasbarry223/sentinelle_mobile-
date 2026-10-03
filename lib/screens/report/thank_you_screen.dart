import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Illustration: Citizen protecting with shield
              SizedBox(
                width: 220,
                height: 220,
                child: CustomPaint(
                  painter: _ThankYouIllustrationPainter(),
                ),
              ),
              const SizedBox(height: 36),

              // Title
              Text(
                'Merci, vous protégez d\'autres Maliens.',
                textAlign: TextAlign.center,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 14),

              // Subtitle
              Text(
                'Votre signalement anonyme aide toute la communauté.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),

              const Spacer(flex: 2),

              // Button 1: Retour à l'accueil
              ElevatedButton(
                onPressed: () {
                  context.read<AppState>().setNavIndex(0);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Retour à l\'accueil'),
              ),
              const SizedBox(height: 14),

              // Button 2: Voir l'historique
              OutlinedButton(
                onPressed: () {
                  context.read<AppState>().setNavIndex(1);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Voir l\'historique'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThankYouIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bgRadius = size.width * 0.42;

    // Soft beige circle backdrop
    canvas.drawCircle(center, bgRadius, Paint()..color = const Color(0xFFF7ECD8));

    // Floating dots
    final dotGreen = Paint()..color = const Color(0xFF4ADE80);
    final dotOchre = Paint()..color = const Color(0xFFFCD34D);
    canvas.drawCircle(Offset(center.dx - 50, center.dy - 65), 5, dotGreen);
    canvas.drawCircle(Offset(center.dx + 45, center.dy - 70), 5, dotGreen);
    canvas.drawCircle(Offset(center.dx + 45, center.dy + 60), 4, dotGreen);
    canvas.drawCircle(Offset(center.dx - 70, center.dy + 55), 6, dotOchre);

    // Person on left
    final personCenter = Offset(center.dx - 30, center.dy + 10);
    final path = Path()
      ..moveTo(personCenter.dx - 28, personCenter.dy + 40)
      ..lineTo(personCenter.dx - 12, personCenter.dy - 10)
      ..lineTo(personCenter.dx + 12, personCenter.dy - 10)
      ..lineTo(personCenter.dx + 28, personCenter.dy + 40)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF166534));

    // Extended arm pointing to shield
    canvas.drawLine(
      Offset(personCenter.dx + 6, personCenter.dy - 2),
      Offset(personCenter.dx + 42, personCenter.dy - 14),
      Paint()
        ..color = const Color(0xFF8D5B28)
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );

    // Head and cap
    canvas.drawCircle(Offset(personCenter.dx, personCenter.dy - 26), 14, Paint()..color = const Color(0xFF8D5B28));
    canvas.drawArc(
      Rect.fromCircle(center: Offset(personCenter.dx, personCenter.dy - 28), radius: 15),
      3.14,
      3.14,
      true,
      Paint()..color = const Color(0xFFC88A28),
    );

    // Golden Shield with heart inside
    final shieldCenter = Offset(center.dx + 45, center.dy - 2);
    final shieldPath = Path()
      ..moveTo(shieldCenter.dx - 18, shieldCenter.dy - 22)
      ..lineTo(shieldCenter.dx + 18, shieldCenter.dy - 22)
      ..lineTo(shieldCenter.dx + 18, shieldCenter.dy)
      ..quadraticBezierTo(shieldCenter.dx + 18, shieldCenter.dy + 26, shieldCenter.dx, shieldCenter.dy + 36)
      ..quadraticBezierTo(shieldCenter.dx - 18, shieldCenter.dy + 26, shieldCenter.dx - 18, shieldCenter.dy)
      ..close();
    canvas.drawPath(shieldPath, Paint()..color = const Color(0xFFC88A28));

    // Heart inside shield
    final heartPath = Path()
      ..moveTo(shieldCenter.dx, shieldCenter.dy + 12)
      ..cubicTo(shieldCenter.dx - 12, shieldCenter.dy, shieldCenter.dx - 12, shieldCenter.dy - 8, shieldCenter.dx, shieldCenter.dy - 2)
      ..cubicTo(shieldCenter.dx + 12, shieldCenter.dy - 8, shieldCenter.dx + 12, shieldCenter.dy, shieldCenter.dx, shieldCenter.dy + 12)
      ..close();
    canvas.drawPath(heartPath, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
