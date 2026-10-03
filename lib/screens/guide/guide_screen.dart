import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'common_scams_screen.dart';
import 'mini_quiz_screen.dart';
import 'personal_data_screen.dart';
import 'victim_guide_screen.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Guide',
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),

              // 1. Emergency Victim Card (Light Pink Alert)
              _buildVictimCard(context),
              const SizedBox(height: 16),

              // 2. Arnaques courantes Card
              _buildMenuCard(
                context: context,
                icon: Icons.filter_center_focus_rounded,
                iconBg: const Color(0xFFEFF8F2),
                iconColor: AppColors.primaryGreen,
                title: 'Arnaques courantes',
                subtitle: '7 fiches pour reconnaître les pièges',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CommonScamsScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // 3. Protéger mes données Card
              _buildMenuCard(
                context: context,
                icon: Icons.lock_outline_rounded,
                iconBg: AppColors.ochreLight,
                iconColor: AppColors.ochreDark,
                title: 'Protéger mes données',
                subtitle: 'CNI, PIN, OTP, photos : les règles d\'or',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PersonalDataScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // 4. Mini-quiz vigilant Card
              _buildMenuCard(
                context: context,
                icon: Icons.verified_outlined,
                iconBg: AppColors.ochreLight,
                iconColor: AppColors.ochreDark,
                title: 'Mini-quiz vigilant',
                subtitle: '5 questions pour tester vos réflexes',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MiniQuizScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVictimCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const VictimGuideScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFEECEB),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFFCA5A5), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: Color(0xFFDC2626),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'J\'ai été victime d\'une arnaque',
                    style: AppTypography.titleSmall.copyWith(
                      color: const Color(0xFFDC2626),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Respirez. Vous pouvez agir tout de suite.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFFDC2626),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
