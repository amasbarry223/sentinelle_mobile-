import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/audio_bambara_button.dart';
import '../../widgets/onboarding_illustrations.dart';

class PersonalDataScreen extends StatelessWidget {
  const PersonalDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Protéger mes données'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration: Phone with padlock
              const OnboardingIllustration(step: 2, size: 180),
              const SizedBox(height: 18),

              // Subtitle
              Text(
                'Six choses que personne ne doit jamais vous demander.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // Rule 1: Votre PIN Mobile Money
              _buildRuleCard(
                icon: Icons.key_outlined,
                iconBg: const Color(0xFFFDE8E8),
                iconColor: const Color(0xFFDC2626),
                title: 'Votre PIN Mobile Money',
                audioText: 'I ka PIN kɔdi : kana a di mɔgɔ si ma, hali agent yɛrɛ.',
                boldWarning: 'Ne partagez jamais votre PIN, même à un « agent ».',
                why: 'Votre PIN est la clé de votre argent. Un vrai agent ne le demande jamais.',
                whatIfAsked: 'Raccrochez et appelez votre opérateur officiel.',
              ),
              const SizedBox(height: 16),

              // Rule 2: Votre code OTP
              _buildRuleCard(
                icon: Icons.chat_bubble_outline_rounded,
                iconBg: const Color(0xFFFDE8E8),
                iconColor: const Color(0xFFDC2626),
                title: 'Votre code OTP',
                audioText: 'OTP kɔdi min bɛ na SMS la, kana a fɔ mɔgɔ si ye.',
                boldWarning: 'Ne communiquez jamais un code reçu par SMS.',
                why: 'Le code OTP sert à valider une opération sur VOTRE compte.',
                whatIfAsked: 'Refusez et signalez le numéro.',
              ),
              const SizedBox(height: 16),

              // Rule 3: Votre CNI / NINA
              _buildRuleCard(
                icon: Icons.badge_outlined,
                iconBg: AppColors.ochreLight,
                iconColor: AppColors.ochreDark,
                title: 'Votre CNI ou fiche NINA',
                audioText: 'I ka batange walima NINA ja, kana a bila gansan.',
                boldWarning: 'Ne partagez jamais de photo nette sans filigrane protecteur.',
                why: 'Les escrocs s\'en servent pour ouvrir de faux comptes en votre nom.',
                whatIfAsked: 'Écrivez en travers de la photo « Réservé à... » avant tout envoi.',
              ),
              const SizedBox(height: 16),

              // Rule 4: Vos photos intimes ou selfies
              _buildRuleCard(
                icon: Icons.camera_alt_outlined,
                iconBg: AppColors.ochreLight,
                iconColor: AppColors.ochreDark,
                title: 'Vos photos personnelles et selfies',
                audioText: 'I yɛrɛ ja gansanw kana ci mɔgɔ ma min t\'i dɔn.',
                boldWarning: 'Méfiez-vous du chantage à la vidéo ou fausse relation amoureuse.',
                why: 'Ces photos sont utilisées pour le chantage affectif et l\'extorsion.',
                whatIfAsked: 'Coupez tout contact et bloquez l\'escroc.',
              ),
              const SizedBox(height: 16),

              // Rule 5: Accès bancaires
              _buildRuleCard(
                icon: Icons.account_balance_outlined,
                iconBg: const Color(0xFFEFF8F2),
                iconColor: AppColors.primaryGreen,
                title: 'Vos identifiants bancaires',
                audioText: 'Banki kɔnti kunnafoniw bɛ mara i yɛrɛ bolo.',
                boldWarning: 'Aucun conseiller n\'a besoin de votre mot de passe pour vous aider.',
                why: 'Les banques disposent d\'outils internes sans avoir à demander vos accès.',
                whatIfAsked: 'Déplacez-vous à votre agence bancaire physique.',
              ),
              const SizedBox(height: 16),

              // Rule 6: Mots de passe réseaux sociaux
              _buildRuleCard(
                icon: Icons.lock_outline_rounded,
                iconBg: const Color(0xFFEFF8F2),
                iconColor: AppColors.primaryGreen,
                title: 'Vos accès Facebook & WhatsApp',
                audioText: 'I ka WhatsApp kɔdi kana di mɔgɔ ma kosɔn a b\'a pirater.',
                boldWarning: 'Activez la vérification en deux étapes sur WhatsApp.',
                why: 'Les pirates usurpent votre compte pour arnaquer tous vos contacts.',
                whatIfAsked: 'Ne transmettez jamais le code de connexion à 6 chiffres.',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String audioText,
    required String boldWarning,
    required String why,
    required String whatIfAsked,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon, Title, and BM Audio
          Row(
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
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              AudioBambaraButton(speechText: audioText),
            ],
          ),
          const SizedBox(height: 14),

          // Red Warning Headline
          Text(
            boldWarning,
            style: AppTypography.bodyMedium.copyWith(
              color: const Color(0xFFDC2626),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),

          // Why
          RichText(
            text: TextSpan(
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: 'Pourquoi : ',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                TextSpan(text: why),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // What if asked
          RichText(
            text: TextSpan(
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: 'Si on vous le demande : ',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                TextSpan(text: whatIfAsked),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
