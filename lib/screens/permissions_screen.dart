import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/privacy_banner.dart';
import 'language_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _readSms = false;
  bool _overlay = false;
  bool _notifications = false;

  void _continue() {
    context.read<AppState>().updatePermissions(
          sms: _readSms,
          overlay: _overlay,
          notifs: _notifications,
        );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LanguageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      'Pour vous protéger, Sentinelle a besoin de votre accord',
                      style: AppTypography.displayLarge.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Privacy Banner
                    const PrivacyBanner(),
                    const SizedBox(height: 20),

                    // Disclaimer text
                    Text(
                      "Toutes facultatives. Vous pourrez changer d'avis.",
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Permission Card 1: SMS
                    _buildPermissionCard(
                      icon: Icons.chat_bubble_outline_rounded,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: AppColors.primaryGreen,
                      title: "Lire les SMS entrants",
                      why: "Pour vous alerter tout de suite si un SMS est suspect.",
                      whatWeDoNot: "Vos messages ne sont jamais envoyés ni lus par quelqu'un.",
                      value: _readSms,
                      onChanged: (val) => setState(() => _readSms = val),
                    ),
                    const SizedBox(height: 16),

                    // Permission Card 2: Overlay
                    _buildPermissionCard(
                      icon: Icons.filter_center_focus_rounded,
                      iconBg: const Color(0xFFE0F2FE),
                      iconColor: const Color(0xFF0284C7),
                      title: "Afficher des alertes par-dessus les applications",
                      why: "Pour vous avertir avant de cliquer sur un lien dangereux.",
                      whatWeDoNot: "Nous ne modifions rien dans vos autres applications.",
                      value: _overlay,
                      onChanged: (val) => setState(() => _overlay = val),
                    ),
                    const SizedBox(height: 16),

                    // Permission Card 3: Notifications
                    _buildPermissionCard(
                      icon: Icons.notifications_none_rounded,
                      iconBg: const Color(0xFFF3E8FF),
                      iconColor: const Color(0xFF9333EA),
                      title: "Notifications",
                      why: "Pour recevoir les alertes de sécurité importantes.",
                      whatWeDoNot: "Pas de publicité, uniquement des avis de protection.",
                      value: _notifications,
                      onChanged: (val) => setState(() => _notifications = val),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom CTAs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _continue,
                    child: const Text('Activer la protection'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _continue,
                    child: Text(
                      'Plus tard',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.ochreDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String why,
    required String whatWeDoNot,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: "Pourquoi : ",
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                TextSpan(text: why),
              ],
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: "Ce que nous ne faisons pas : ",
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                TextSpan(text: whatWeDoNot),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
