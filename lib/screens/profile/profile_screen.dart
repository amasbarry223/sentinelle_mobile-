import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../language_screen.dart';
import '../onboarding_screen.dart';
import '../permissions_screen.dart';
import 'privacy_screen.dart';
import 'rules_update_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Header Avatar and Name
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        appState.userName.isNotEmpty ? appState.userName[0].toUpperCase() : 'A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.userName,
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appState.userSubtitle,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Card Group 1 (Compte, Protection, Langue)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.cardBorder, width: 1.2),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Compte',
                      subtitle: appState.userName,
                      onTap: () {
                        _showEditNameDialog(context, appState);
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildSettingsItem(
                      icon: Icons.verified_user_outlined,
                      title: 'Protection',
                      subtitle: 'Permissions actives',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const PermissionsScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildSettingsItem(
                      icon: Icons.translate_rounded,
                      title: 'Langue',
                      subtitle: appState.language == 'FR' ? 'Français' : 'Bamanankan',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const LanguageScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Card Group 2 (Confidentialité, Mises à jour, Aide, À propos)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.cardBorder, width: 1.2),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Confidentialité',
                      subtitle: '${appState.reports.length} signalement(s)',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildSettingsItem(
                      icon: Icons.sync_rounded,
                      title: 'Mises à jour des règles',
                      subtitle: appState.rulesVersion,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const RulesUpdateScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildSettingsItem(
                      icon: Icons.auto_stories_outlined,
                      title: "Tutoriel d'accueil",
                      subtitle: "Revoir la présentation et les 4 conseils",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildSettingsItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Aide',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Centre d'assistance disponible via WhatsApp ou SMS."),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildSettingsItem(
                      icon: Icons.info_outline_rounded,
                      title: 'À propos',
                      onTap: () {
                        _showAboutModal(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Footer version
              Text(
                'Sentinelle Mali · v1.0.0',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF8F2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
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

  void _showEditNameDialog(BuildContext context, AppState state) {
    final controller = TextEditingController(text: state.userName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Modifier le prénom'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Prénom'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                state.updateUserName(controller.text.trim());
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showAboutModal(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Sentinelle Mali',
      applicationVersion: 'v1.0.0',
      applicationIcon: const Icon(Icons.shield_rounded, size: 48, color: AppColors.primaryGreen),
      children: [
        const SizedBox(height: 12),
        const Text(
          'Sentinelle Mali est une application d\'alerte et d\'analyse locale de sécurité mobile '
          'conçue pour protéger les citoyens contre les arnaques financières, les faux agents Mobile Money et le phishing au Mali.',
        ),
      ],
    );
  }
}
