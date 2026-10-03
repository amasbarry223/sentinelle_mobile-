import 'package:flutter/material.dart';
import '../../data/quiz_data.dart';
import '../../models/quiz_question.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class MiniQuizScreen extends StatefulWidget {
  const MiniQuizScreen({super.key});

  @override
  State<MiniQuizScreen> createState() => _MiniQuizScreenState();
}

class _MiniQuizScreenState extends State<MiniQuizScreen> {
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _hasAnswered = false;
  int _score = 0;

  final List<QuizQuestion> _questions = QuizData.questions;

  void _onOptionTap(int index) {
    if (_hasAnswered) return;
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _onNext() {
    if (_selectedOptionIndex == null) return;

    if (!_hasAnswered) {
      // Validate answer
      final isCorrect = _selectedOptionIndex == _questions[_currentIndex].correctIndex;
      if (isCorrect) _score++;
      setState(() {
        _hasAnswered = true;
      });
    } else {
      // Go to next question or show summary
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOptionIndex = null;
          _hasAnswered = false;
        });
      } else {
        _showQuizFinishedDialog();
      }
    }
  }

  void _showQuizFinishedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Center(
          child: Text(
            'Quiz terminé !',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _score >= 4 ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_score/${_questions.length}',
                  style: AppTypography.displayLarge.copyWith(
                    color: _score >= 4 ? AppColors.primaryGreen : AppColors.ochreDark,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              _score >= 4
                  ? 'Bravo ! Vous avez d\'excellents réflexes pour déjouer les arnaques.'
                  : 'Bonne révision ! Continuez à appliquer les règles d\'or pour rester en sécurité.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Retour au guide'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mini-quiz vigilant'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE5E1D8),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.ochre),
              minHeight: 4,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "QUESTION 1/5"
                    Text(
                      'QUESTION ${_currentIndex + 1}/${_questions.length}',
                      style: AppTypography.badgeText.copyWith(
                        color: AppColors.ochreDark,
                        letterSpacing: 1.0,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Question text
                    Text(
                      currentQ.question,
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Options List
                    ...currentQ.options.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final text = entry.value;
                      final isSelected = _selectedOptionIndex == idx;

                      Color cardBg = Colors.white;
                      Color borderColor = AppColors.cardBorder;
                      Color textColor = AppColors.textPrimary;

                      if (_hasAnswered) {
                        if (idx == currentQ.correctIndex) {
                          cardBg = const Color(0xFFDCFCE7);
                          borderColor = AppColors.primaryGreen;
                          textColor = AppColors.primaryGreenDark;
                        } else if (isSelected && idx != currentQ.correctIndex) {
                          cardBg = const Color(0xFFFEE2E2);
                          borderColor = const Color(0xFFDC2626);
                          textColor = const Color(0xFFDC2626);
                        }
                      } else if (isSelected) {
                        cardBg = const Color(0xFFEFF8F2);
                        borderColor = AppColors.primaryGreen;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: GestureDetector(
                          onTap: () => _onOptionTap(idx),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: borderColor,
                                width: isSelected || (_hasAnswered && idx == currentQ.correctIndex) ? 1.8 : 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    text,
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: textColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                if (_hasAnswered && idx == currentQ.correctIndex)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 20),
                                if (_hasAnswered && isSelected && idx != currentQ.correctIndex)
                                  const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626), size: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    if (_hasAnswered) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, color: AppColors.primaryGreen, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                currentQ.explanation,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primaryGreenDark,
                                  fontSize: 13,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom CTA: Suivant
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: ElevatedButton(
                onPressed: _selectedOptionIndex != null ? _onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedOptionIndex != null ? const Color(0xFF7CA089) : const Color(0xFFCBD5E1),
                ),
                child: Text(_hasAnswered ? 'Continuer' : 'Suivant'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
