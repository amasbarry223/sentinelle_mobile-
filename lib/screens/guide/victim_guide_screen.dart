import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/audio_bambara_button.dart';

class VictimGuideScreen extends StatefulWidget {
  const VictimGuideScreen({super.key});

  @override
  State<VictimGuideScreen> createState() => _VictimGuideScreenState();
}

class _VictimGuideScreenState extends State<VictimGuideScreen> {
  final List<String> _situations = const [
    "J'ai donné mon PIN / OTP",
    "J'ai envoyé de l'argent",
    "J'ai cliqué sur un lien",
    "J'ai partagé ma CNI / photos",
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final completedCount = appState.completedVictimSteps.length;
    const totalSteps = 5;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("J'ai été victime"),
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
              // Emergency Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEECEB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFCA5A5), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Respirez. Vous pouvez agir tout de suite.',
                      style: AppTypography.titleSmall.copyWith(
                        color: const Color(0xFFDC2626),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Suivez les étapes une par une : chaque geste compte.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Situation Selector
              Text(
                'Votre situation',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _situations.map((sit) {
                  final isSelected = appState.victimSelectedSituation == sit;
                  return GestureDetector(
                    onTap: () => appState.setVictimSituation(sit),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFDC2626) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFDC2626) : AppColors.cardBorder,
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        sit,
                        style: AppTypography.bodySmall.copyWith(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Progress Bar
              Text(
                '$completedCount/$totalSteps étapes terminées',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completedCount / totalSteps,
                  backgroundColor: const Color(0xFFE5E1D8),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.ochre),
                  minHeight: 5,
                ),
              ),
              const SizedBox(height: 24),

              // Step 1: Sécuriser
              _buildStepCard(
                stepNum: 1,
                title: 'Sécuriser',
                timeEstimate: '≈ 10 min',
                items: [
                  'Changez votre PIN Mobile Money tout de suite',
                  'Appelez votre opérateur pour bloquer le compte si besoin',
                  'Orange : 133 · Moov : 133 · Wave : *115#',
                ],
                isDone: appState.completedVictimSteps.contains(1),
                onToggleDone: () => appState.toggleVictimStep(1),
                audioText: "Sécuriser votre compte : changez votre code secret tout de suite et appelez le 133.",
                showCallButton: true,
              ),
              const SizedBox(height: 16),

              // Step 2: Bloquer
              _buildStepCard(
                stepNum: 2,
                title: 'Bloquer le fraudeur',
                timeEstimate: '≈ 5 min',
                items: [
                  'Bloquez le numéro dans les paramètres de votre téléphone',
                  'Faites une capture d\'écran des messages ou de l\'appel comme preuve',
                  'Ne répondez plus à aucune relance',
                ],
                isDone: appState.completedVictimSteps.contains(2),
                onToggleDone: () => appState.toggleVictimStep(2),
                audioText: "Bloquer le numéro de l'escroc et gardez les captures comme preuves.",
              ),
              const SizedBox(height: 16),

              // Step 3: Prévenir ses proches
              _buildStepCard(
                stepNum: 3,
                title: 'Prévenir vos proches',
                timeEstimate: '≈ 5 min',
                items: [
                  'Avertissez votre famille qu\'un escroc pourrait les contacter en votre nom',
                  'Dites-leur de ne jamais envoyer d\'argent sans appel direct',
                ],
                isDone: appState.completedVictimSteps.contains(3),
                onToggleDone: () => appState.toggleVictimStep(3),
                audioText: "Avertissez votre famille afin qu'ils ne tombent pas dans le piège.",
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required int stepNum,
    required String title,
    required String timeEstimate,
    required List<String> items,
    required bool isDone,
    required VoidCallback onToggleDone,
    required String audioText,
    bool showCallButton = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F4422),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$stepNum',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.ochreLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    timeEstimate,
                    style: AppTypography.badgeText.copyWith(
                      color: AppColors.ochreDark,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Items list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...items.map((it) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_rounded, color: AppColors.primaryGreen, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            it,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.35,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 4),

                // Audio & Call Button Row
                Row(
                  children: [
                    AudioBambaraButton(speechText: audioText),
                    if (showCallButton) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Numéros d'urgence : Orange (133), Moov (133), Wave (*115#)"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.phone_outlined, size: 18),
                          label: const Text('Appeler l\'opérateur', style: TextStyle(fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryGreen,
                            side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            minimumSize: const Size(0, 42),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // "Étape terminée" Switch Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Étape terminée',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Switch(
                  value: isDone,
                  onChanged: (val) => onToggleDone(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
