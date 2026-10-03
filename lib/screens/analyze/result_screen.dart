import 'package:flutter/material.dart';
import '../../models/analysis_result.dart';
import '../../models/risk_level.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/audio_bambara_button.dart';
import '../../widgets/gauge_painter.dart';
import '../report/report_screen.dart';

class ResultScreen extends StatefulWidget {
  final AnalysisResult result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String _verdictLanguage = 'FR'; // 'FR' or 'BM'

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final level = result.riskLevel;

    // Header background tint based on risk
    Color headerBg;
    switch (level) {
      case RiskLevel.critique:
        headerBg = const Color(0xFFFCE8E8);
        break;
      case RiskLevel.eleve:
        headerBg = const Color(0xFFFFEDD5);
        break;
      case RiskLevel.modere:
        headerBg = const Color(0xFFFEF3C7);
        break;
      case RiskLevel.faible:
        headerBg = const Color(0xFFE8F5E9);
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Résultat'),
        backgroundColor: headerBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Alerte copiée pour partage sécurisé !"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section with Gauge
            Container(
              width: double.infinity,
              color: headerBg,
              padding: const EdgeInsets.only(bottom: 24, top: 8),
              child: Column(
                children: [
                  // Animated Speedometer Gauge
                  GaugeWidget(score: result.score, size: 230),
                  const SizedBox(height: 14),

                  // Risk Level Pill Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: level.bgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: level.borderColor, width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(level.icon, color: level.color, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '${level.label} · ${result.score}/100',
                          style: AppTypography.badgeText.copyWith(
                            color: level.color,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Bambara Audio Trigger
                  AudioBambaraButton(speechText: result.verdictBm),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Verdict Card with FR / BM Toggle
                  _buildVerdictCard(result),
                  const SizedBox(height: 14),

                  // 2. Action Advice Banner Card
                  _buildAdviceCard(result),
                  const SizedBox(height: 24),

                  // 3. Section: Pourquoi ce score ?
                  Text(
                    'Pourquoi ce score ?',
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Reasons and Query Preview Card
                  _buildExplanationCard(result),
                  const SizedBox(height: 24),

                  // 4. Report Action Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReportScreen(
                            prefilledContent: result.query,
                            initialType: result.type,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ochre,
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.flag_outlined, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Signaler cette arnaque',
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerdictCard(AnalysisResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'VERDICT',
                style: AppTypography.badgeText.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                  fontSize: 12,
                ),
              ),
              // Segmented FR / BM toggle
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EFEA),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    _buildLangToggle('FR', _verdictLanguage == 'FR'),
                    _buildLangToggle('BM', _verdictLanguage == 'BM'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _verdictLanguage == 'FR' ? result.verdictFr : result.verdictBm,
            style: AppTypography.titleSmall.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangToggle(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _verdictLanguage = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: AppTypography.badgeText.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildAdviceCard(AnalysisResult result) {
    final level = result.riskLevel;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: level.bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: level.borderColor, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(level.icon, color: level.color, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.adviceHeadline,
                  style: AppTypography.titleSmall.copyWith(
                    color: level.color,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                if (result.adviceBody != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    result.adviceBody!,
                    style: AppTypography.bodySmall.copyWith(
                      color: level.color.withValues(alpha: 0.9),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard(AnalysisResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: result.reasons.map((reason) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3EF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E1D8)),
                ),
                child: Text(
                  reason,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Message Preview with subtle highlighted box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              result.highlightedText,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
