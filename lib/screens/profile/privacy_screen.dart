import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/privacy_banner.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final reports = appState.reports;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Confidentialité'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Minimisation
              const PrivacyBanner(
                text: "Minimisation : Sentinelle ne collecte que ce qui est nécessaire. Les analyses restent sur votre téléphone.",
              ),
              const SizedBox(height: 20),

              // Settings Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.cardBorder, width: 1.2),
                ),
                child: Column(
                  children: [
                    // Effacer l'historique
                    _buildActionRow(
                      icon: Icons.delete_outline_rounded,
                      iconBg: const Color(0xFFEFF8F2),
                      iconColor: AppColors.primaryGreen,
                      title: "Effacer l'historique",
                      onTap: () {
                        appState.clearAllHistory();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Historique local effacé avec succès."),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),

                    // Exporter mes données
                    _buildActionRow(
                      icon: Icons.file_download_outlined,
                      iconBg: const Color(0xFFEFF8F2),
                      iconColor: AppColors.primaryGreen,
                      title: "Exporter mes données",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Exportation chiffrée générée sur l'appareil."),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),

                    // Simuler le mode hors-ligne
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF8F2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.cloud_off_rounded,
                              color: AppColors.primaryGreen,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Simuler le mode hors-ligne',
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Switch(
                            value: appState.offlineMode,
                            onChanged: (val) => appState.toggleOfflineMode(val),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider),

                    // Politique de confidentialité lisible
                    _buildActionRow(
                      icon: Icons.description_outlined,
                      iconBg: const Color(0xFFEFF8F2),
                      iconColor: AppColors.primaryGreen,
                      title: "Politique de confidentialité lisible",
                      onTap: () {
                        _showPrivacyModal(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Section: Mes signalements
              Text(
                'Mes signalements',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 14),

              // Reports list
              ...reports.map((report) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder, width: 1.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.title,
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              report.dateText,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            report.status,
                            style: AppTypography.badgeText.copyWith(
                              color: AppColors.primaryGreenDark,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
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

  void _showPrivacyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Politique de confidentialité', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Text(
              'Sentinelle Mali est conçu selon le principe de la minimisation stricte des données :\n\n'
              '• Vos SMS et messages restent sur votre téléphone.\n'
              '• Le moteur d\'analyse fonctionne en local sans serveur externe.\n'
              '• Les signalements communautaires sont strictement anonymisés.\n'
              '• Aucun identifiant ni coordonnée personnelle n\'est transmis.',
              style: AppTypography.bodyMedium.copyWith(height: 1.45),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Compris'),
            ),
          ],
        ),
      ),
    );
  }
}
