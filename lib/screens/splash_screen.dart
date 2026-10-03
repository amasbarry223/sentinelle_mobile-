import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/background_pattern.dart';
import '../widgets/djenne_logo.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_progress >= 1.0) {
        timer.cancel();
        _navigateToNext();
      } else {
        setState(() {
          _progress += 0.02;
        });
      }
    });
  }

  void _navigateToNext() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => const OnboardingScreen(),
        transitionsBuilder: (context, anim, secAnim, child) {
          return FadeTransition(opacity: anim, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundPattern(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                // Center Djenné emblem
                const DjenneLogo(size: 155),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Sentinelle Mali',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle
                Text(
                  'Ne vous faites plus arnaquer.',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),

                const Spacer(flex: 2),

                // Progress Bar
                Container(
                  width: 170,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: AppColors.ochre.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 170 * _progress.clamp(0.0, 1.0),
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: AppColors.ochre,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Subtext
                Text(
                  'Initialisation du moteur de protection...',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
