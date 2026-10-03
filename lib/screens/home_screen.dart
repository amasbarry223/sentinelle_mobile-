import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/scam_data.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/audio_bambara_button.dart';
import '../widgets/djenne_logo.dart';
import 'analyze/analyze_screen.dart';
import 'guide/common_scams_screen.dart';
import 'guide/personal_data_screen.dart';
import 'guide/scam_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenAnalyze;

  const HomeScreen({
    super.key,
    required this.onOpenAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Bar
              _buildHeader(context, appState),
              const SizedBox(height: 20),

              // 2. Protection Hero Status Card
              _buildHeroCard(context, appState),
              const SizedBox(height: 18),

              // 3. Main Call To Action: Analyser un message ou un lien
              _buildMainAnalyzeButton(context),
              const SizedBox(height: 18),

              // 4. 2x2 Quick Actions Grid
              _buildQuickActionsGrid(context),
              const SizedBox(height: 28),

              // 5. Recent Alerts Section (Alertes récentes)
              _buildRecentAlertsSection(context, appState),
              const SizedBox(height: 28),

              // 6. Conseil du jour Section
              _buildTipOfTheDaySection(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const DjenneLogo(size: 44),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, ${state.userName}',
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Restez protégé aujourd'hui.",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            // Bell Notification Button with red dot
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CommonScamsScreen()),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cardBorder, width: 1.2),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.riskCritical,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Profile Avatar Circle
            GestureDetector(
              onTap: () => state.setNavIndex(4), // Go to Profile
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    state.userName.isNotEmpty ? state.userName[0].toUpperCase() : 'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context, AppState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle radar rings watermark on the right
          Positioned(
            right: -30,
            top: -30,
            bottom: -30,
            child: SizedBox(
              width: 160,
              height: 160,
              child: CustomPaint(
                painter: _HeroRingsPainter(),
              ),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shield Check icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vous êtes protégé',
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '14 analyses ce mois · 3 arnaques évitées',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => state.setNavIndex(4), // Go to profile/protection settings
                      child: Text(
                        'Gérer',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.ochreLight,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.ochreLight,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainAnalyzeButton(BuildContext context) {
    return GestureDetector(
      onTap: onOpenAnalyze,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.ochre,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.ochre.withValues(alpha: 0.28),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.center_focus_strong_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              'Analyser un message ou un lien',
              style: AppTypography.titleSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildQuickActionCard(
                context: context,
                icon: Icons.chat_bubble_outline_rounded,
                title: 'SMS /\nMessage',
                onTap: () => _openAnalyzeWithTab(context, 0),
              ),
              const SizedBox(height: 12),
              _buildQuickActionCard(
                context: context,
                icon: Icons.phone_outlined,
                title: 'Numéro',
                onTap: () => _openAnalyzeWithTab(context, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              _buildQuickActionCard(
                context: context,
                icon: Icons.link_rounded,
                title: 'Lien',
                onTap: () => _openAnalyzeWithTab(context, 1),
              ),
              const SizedBox(height: 12),
              _buildQuickActionCard(
                context: context,
                icon: Icons.account_balance_wallet_outlined,
                title: 'Mobile\nMoney',
                onTap: () => _openAnalyzeWithTab(context, 3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF8F2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryGreen,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTypography.titleSmall.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAnalyzeWithTab(BuildContext context, int tabIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnalyzeScreen(initialTabIndex: tabIndex),
      ),
    );
  }

  Widget _buildRecentAlertsSection(BuildContext context, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Alertes récentes',
              style: AppTypography.titleMedium.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CommonScamsScreen()),
                );
              },
              child: Text(
                'Voir tout',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.ochreDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              // Card 1: Fausse campagne Remboursement Orange Money
              _buildAlertCard(
                context: context,
                badgeLabel: 'Risque élevé',
                badgeColor: AppColors.riskElevated,
                badgeBg: AppColors.riskElevatedBg,
                badgeIcon: Icons.warning_amber_rounded,
                title: 'Fausse campagne « Remboursement Orange Money »',
                reportsText: '312 signalements · il y a 2 h',
                audioText: 'Fausse campagne Remboursement Orange Money. Ngalon don kana sara si bila yen.',
                onTap: () {
                  final scam = ScamData.commonScams.firstWhere(
                    (s) => s.id == 'scam_5',
                    orElse: () => ScamData.commonScams[0],
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ScamDetailScreen(scam: scam)),
                  );
                },
              ),
              const SizedBox(width: 14),

              // Card 2: Faux concours SMS
              _buildAlertCard(
                context: context,
                badgeLabel: 'Risque critique',
                badgeColor: AppColors.riskCritical,
                badgeBg: AppColors.riskCriticalBg,
                badgeIcon: Icons.front_hand_rounded,
                title: 'Faux concours « Gagnez 500 000 F » par SMS',
                reportsText: '187 signalements · il y a 5 h',
                audioText: 'Faux concours par SMS. Kana i ka wari bila kɔnɔ.',
                onTap: () {
                  final scam = ScamData.commonScams.firstWhere(
                    (s) => s.id == 'scam_3',
                    orElse: () => ScamData.commonScams[0],
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ScamDetailScreen(scam: scam)),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertCard({
    required BuildContext context,
    required String badgeLabel,
    required Color badgeColor,
    required Color badgeBg,
    required IconData badgeIcon,
    required String title,
    required String reportsText,
    required String audioText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 275,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Risk Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon, color: badgeColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        badgeLabel,
                        style: AppTypography.badgeText.copyWith(
                          color: badgeColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bambara Audio Pill
                AudioBambaraButton(speechText: audioText),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 1.3,
              ),
            ),
            const Spacer(),

            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  reportsText,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipOfTheDaySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Conseil du jour',
          style: AppTypography.titleMedium.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PersonalDataScreen()),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.cardBorder, width: 1.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.ochreLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppColors.ochreDark,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gardez votre code secret',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ne partagez jamais le code reçu par SMS (OTP), même si la personne prétend être un agent Orange Money ou Wave.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.9, size.height * 0.5);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, i * 28.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
