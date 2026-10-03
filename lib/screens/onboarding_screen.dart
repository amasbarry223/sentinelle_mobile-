import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/onboarding_illustrations.dart';
import 'permissions_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      title: "Les arnaques sont partout",
      description:
          "Faux agents Mobile Money, faux gains, demandes de code : les fraudeurs visent les Maliens chaque jour.",
    ),
    _OnboardingData(
      title: "Sentinelle analyse pour vous",
      description:
          "Collez un SMS, un lien ou un numéro. Vous voyez un score de risque et pourquoi.",
    ),
    _OnboardingData(
      title: "Vos messages restent chez vous",
      description:
          "L'analyse se fait sur votre téléphone, même sans internet. Rien n'est envoyé sans votre accord.",
    ),
    _OnboardingData(
      title: "Ensemble contre la fraude, en bambara aussi",
      description:
          "Signalez une arnaque pour protéger les autres. Écoutez les alertes en bambara.",
    ),
  ];

  void _goToNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _goToPrev() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const PermissionsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with "Passer"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _finishOnboarding,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.ochreDark,
                    ),
                    child: Text(
                      'Passer',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.ochreDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration
                        OnboardingIllustration(step: index, size: 240),
                        const SizedBox(height: 48),

                        // Title
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Description
                        Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.45,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dot Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final isSelected = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isSelected ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.ochre : const Color(0xFFE2D9CC),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),

            // Bottom Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _currentPage == 0
                  ? ElevatedButton(
                      onPressed: _goToNext,
                      child: const Text('Suivant'),
                    )
                  : Row(
                      children: [
                        TextButton(
                          onPressed: _goToPrev,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          child: Text(
                            'Précédent',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _goToNext,
                            child: Text(_currentPage == _pages.length - 1 ? 'Commencer' : 'Suivant'),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String description;

  const _OnboardingData({
    required this.title,
    required this.description,
  });
}
