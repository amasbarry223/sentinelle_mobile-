import 'package:flutter/material.dart';
import '../../models/analysis_result.dart';
import '../../theme/app_typography.dart';
import '../../widgets/background_pattern.dart';
import 'result_screen.dart';

class CriticalAlertModal extends StatelessWidget {
  final AnalysisResult result;

  const CriticalAlertModal({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundPattern(
        backgroundColor: const Color(0xFFDC2626), // Vivid alert red
        patternColor: const Color(0xFFB91C1C).withValues(alpha: 0.7),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Raised Hand Stop Badge
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.front_hand_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Title: STOP !
                Text(
                  'STOP !',
                  style: AppTypography.displayLarge.copyWith(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Ne communiquez ni PIN, ni OTP, ni mot de passe.',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),

                // Description
                Text(
                  'Aucun opérateur ne vous demandera votre code. Raccrochez maintenant.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),

                const Spacer(flex: 3),

                // "Voir pourquoi" Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(result: result),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E1E1E),
                    minimumSize: const Size.fromHeight(56),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Voir pourquoi',
                    style: AppTypography.titleSmall.copyWith(
                      color: const Color(0xFF1E1E1E),
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // "Fermer" link
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    'Fermer',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
