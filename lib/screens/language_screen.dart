import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'access_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLang = 'FR';
  bool _voiceOver = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _selectedLang = state.language;
    _voiceOver = state.audioVoiceOver;
  }

  void _continue() {
    context.read<AppState>().setLanguage(_selectedLang);
    context.read<AppState>().toggleAudioVoiceOver(_voiceOver);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Title
              Text(
                'Choisissez votre langue',
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 36),

              // Two Language Cards side-by-side
              Row(
                children: [
                  // Français
                  Expanded(
                    child: _buildLangCard(
                      code: 'FR',
                      name: 'Français',
                      isSelected: _selectedLang == 'FR',
                      badgeBg: _selectedLang == 'FR' ? AppColors.primaryGreen : const Color(0xFFE5E7EB),
                      badgeTextColor: _selectedLang == 'FR' ? Colors.white : AppColors.textSecondary,
                      onTap: () => setState(() => _selectedLang = 'FR'),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Bamanankan
                  Expanded(
                    child: _buildLangCard(
                      code: 'BM',
                      name: 'Bamanankan',
                      isSelected: _selectedLang == 'BM',
                      badgeBg: _selectedLang == 'BM' ? AppColors.ochre : const Color(0xFFE5E7EB),
                      badgeTextColor: _selectedLang == 'BM' ? Colors.white : AppColors.textSecondary,
                      onTap: () => setState(() => _selectedLang = 'BM'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Voice Over Switch Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.cardBorder, width: 1.2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Écouter les alertes à voix haute',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Switch(
                      value: _voiceOver,
                      onChanged: (val) => setState(() => _voiceOver = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Subtext
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'Modifiable à tout moment dans Profil.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Continue Button
              ElevatedButton(
                onPressed: _continue,
                child: const Text('Continuer'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangCard({
    required String code,
    required String name,
    required bool isSelected,
    required Color badgeBg,
    required Color badgeTextColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.cardBorder,
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                code,
                style: AppTypography.badgeText.copyWith(
                  color: badgeTextColor,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
