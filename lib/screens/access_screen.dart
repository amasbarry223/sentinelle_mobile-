import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'guide/personal_data_screen.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import 'profile/privacy_screen.dart';
import 'register_screen.dart';

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  bool _isBambara = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _enterApp() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (route) => false,
    );
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToPrivacy() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PrivacyScreen()),
    );
  }

  void _navigateToSecurityRules() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PersonalDataScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Language Switcher & Bambara Voice Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Identity Label
                    Text(
                      'Sentinelle Mali',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                    ),

                    // Language and Audio controls
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Language Pill
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.cardBorder, width: 1.1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLangTab(
                                label: 'FR',
                                active: !_isBambara,
                                onTap: () => setState(() => _isBambara = false),
                              ),
                              _buildLangTab(
                                label: 'BM',
                                active: _isBambara,
                                onTap: () => setState(() => _isBambara = true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Bambara Audio Speaker Button
                        InkWell(
                          onTap: () {
                            final spokenText = _isBambara
                                ? "I bisimila Sentinelle Mali la. I ka kɛlɛli bɛ kɛ i ka telefoni kan. Foyi tɛ ci kɔkan."
                                : "Bienvenue sur Sentinelle Mali. Vos analyses sont réalisées localement sur votre téléphone.";
                            appState.playBambaraAudio(spokenText, context);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.ochre.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.ochre.withValues(alpha: 0.4)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.volume_up_rounded, color: AppColors.ochreDark, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'BM',
                                  style: TextStyle(
                                    color: AppColors.ochreDark,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Main Title
                Text(
                  _isBambara ? 'I bisimila' : 'Bienvenue',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                Text(
                  _isBambara
                      ? 'I yɛrɛ n’i somɔgɔw lakana kɔrɔbɔriw ma.'
                      : 'Protégez-vous et protégez vos proches.',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(flex: 2),

                // Privacy Banner (Green card -> navigates to PrivacyScreen)
                InkWell(
                  onTap: _navigateToPrivacy,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFA5D6A7),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_outlined,
                          color: AppColors.primaryGreen,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isBambara
                                    ? 'Sɛgɛsɛgɛli bɛ kɛ i ka telefoni kan.'
                                    : 'Analyse faite sur votre téléphone.',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isBambara
                                    ? 'Foyi tɛ ci kɔkan i ka sɔn kɔ.'
                                    : 'Rien n’est envoyé sans votre accord.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primaryGreen.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.primaryGreen,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Main Access Card (White container with CTA buttons)
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.cardBorder, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Primary Button: "Continuer sans compte"
                      ElevatedButton(
                        onPressed: _enterApp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _isBambara ? 'Taa ɲɛ kɔnti t’i fɛ' : 'Continuer sans compte',
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtext
                      Text(
                        _isBambara
                            ? 'I tɔgɔ walima fɛn si tɛ ɲini i fɛ'
                            : 'Aucune donnée personnelle demandée',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Outlined button: "Créer un compte" -> Full Page RegisterScreen
                      OutlinedButton(
                        onPressed: _navigateToRegister,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                          side: const BorderSide(color: AppColors.primaryGreen, width: 1.8),
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _isBambara ? 'Kɔnti kura dabɔ' : 'Créer un compte',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primaryGreen,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // "J'ai déjà un compte" -> Full Page LoginScreen
                Center(
                  child: TextButton(
                    onPressed: _navigateToLogin,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    ),
                    child: Text(
                      _isBambara ? 'Kɔnti bɛ n fɛ kaban' : "J'ai déjà un compte",
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.ochreDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // PIN Warning Notice (Golden Alert Card -> Navigates to PersonalDataScreen)
                InkWell(
                  onTap: _navigateToSecurityRules,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.noticeBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.noticeBorder, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          color: AppColors.noticeText,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _isBambara
                                ? 'Sentinelle tɛna i ka PIN ɲini abada.'
                                : 'Sentinelle ne vous demandera jamais votre code PIN.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.noticeText,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.noticeText,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLangTab({required String label, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textSecondary,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            fontSize: 11.5,
          ),
        ),
      ),
    );
  }
}
