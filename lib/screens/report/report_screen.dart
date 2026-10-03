import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'thank_you_screen.dart';

class ReportScreen extends StatefulWidget {
  final String prefilledContent;
  final String initialType;

  const ReportScreen({
    super.key,
    this.prefilledContent =
        "Orange Money : Vous avez gagné 500 000 FCFA ! Envoyez votre code PIN au 7X XX XX...",
    this.initialType = "SMS",
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _selectedCategory = 'Demande PIN/OTP';

  final List<String> _categories = const [
    'Faux agent MM',
    'Faux transfert',
    'Faux gain',
    'Faux remboursement',
    'Faux blocage',
    'Fausse offre d\'emploi',
    'Phishing',
    'Demande PIN/OTP',
    'Autre',
  ];

  void _submitReport() {
    context.read<AppState>().addReport(
          _selectedCategory,
          widget.prefilledContent,
        );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ThankYouScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Signaler une fraude'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stepper Indicator (Quoi / Envoi / Confirmer)
                    _buildStepper(),
                    const SizedBox(height: 24),

                    // Section 1: Quoi signaler
                    Text(
                      'Quoi signaler',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Preview Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.cardBorder, width: 1.2),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F8F3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: AppColors.primaryGreen,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.initialType,
                                  style: AppTypography.titleSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.prefilledContent,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 2: Type de fraude
                    Text(
                      'Type de fraude',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Selectable Tag Cloud
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryGreen : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryGreen : AppColors.cardBorder,
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              cat,
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
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: ElevatedButton(
                onPressed: _submitReport,
                child: const Text('Suivant'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4.5,
                decoration: BoxDecoration(
                  color: AppColors.ochre,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 4.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E1D8),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 4.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E1D8),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quoi', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text('Envoi', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
            Text('Confirmer', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
          ],
        ),
      ],
    );
  }
}
