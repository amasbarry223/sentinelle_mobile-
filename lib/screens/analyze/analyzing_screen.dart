import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/privacy_banner.dart';
import 'critical_alert_modal.dart';
import 'result_screen.dart';

class AnalyzingScreen extends StatefulWidget {
  final String type;
  final String content;
  final bool askPin;
  final bool isUrgent;
  final bool askPayment;
  final String? situationTag;

  const AnalyzingScreen({
    super.key,
    required this.type,
    required this.content,
    this.askPin = false,
    this.isUrgent = false,
    this.askPayment = false,
    this.situationTag,
  });

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> with SingleTickerProviderStateMixin {
  int _completedSteps = 0;
  Timer? _timer;
  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _startSequence();
  }

  void _startSequence() {
    _timer = Timer.periodic(const Duration(milliseconds: 650), (timer) {
      if (!mounted) return;
      setState(() {
        _completedSteps++;
      });

      if (_completedSteps >= 3) {
        timer.cancel();
        _onAnalysisFinished();
      }
    });
  }

  void _onAnalysisFinished() {
    final result = context.read<AppState>().analyzeInput(
          type: widget.type,
          content: widget.content,
          askPin: widget.askPin,
          isUrgent: widget.isUrgent,
          askPayment: widget.askPayment,
          situationTag: widget.situationTag,
        );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (result.isStopAlert) {
        // Show critical stop alert modal
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, anim, secAnim) => CriticalAlertModal(result: result),
            transitionsBuilder: (context, anim, secAnim, child) {
              return FadeTransition(opacity: anim, child: child);
            },
            transitionDuration: const Duration(milliseconds: 350),
          ),
        );
      } else {
        // Direct to result screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Animated Scanning Radar with Shield
              SizedBox(
                width: 170,
                height: 170,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF5EE),
                        shape: BoxShape.circle,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _radarController,
                      builder: (context, child) {
                        return Container(
                          width: 170 * (0.6 + (_radarController.value * 0.35)),
                          height: 170 * (0.6 + (_radarController.value * 0.35)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryGreen.withValues(alpha: 0.25 * (1.0 - _radarController.value)),
                              width: 2,
                            ),
                          ),
                        );
                      },
                    ),

                    // Horizontal scan bar with shield
                    AnimatedBuilder(
                      animation: _radarController,
                      builder: (context, child) {
                        return Positioned(
                          top: 40 + (_radarController.value * 80),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 38,
                                height: 2,
                                color: AppColors.ochre,
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.shield_outlined,
                                color: AppColors.primaryGreen,
                                size: 24,
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 38,
                                height: 2,
                                color: AppColors.ochre,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Title
              Text(
                'Analyse en cours...',
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 32),

              // Step Checklist
              _buildStepRow(
                label: 'Lecture du contenu...',
                isDone: _completedSteps >= 1,
              ),
              const SizedBox(height: 14),
              _buildStepRow(
                label: "Recherche d'indices...",
                isDone: _completedSteps >= 2,
              ),
              const SizedBox(height: 14),
              _buildStepRow(
                label: 'Calcul du risque...',
                isDone: _completedSteps >= 3,
              ),

              const Spacer(flex: 2),

              // Privacy Banner
              const PrivacyBanner(),
              const SizedBox(height: 24),

              // Annuler
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Annuler',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.ochreDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required String label,
    required bool isDone,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? const Color(0xFFDCFCE7) : Colors.transparent,
              border: Border.all(
                color: isDone ? AppColors.primaryGreen : const Color(0xFFCBD5E1),
                width: 1.8,
              ),
            ),
            child: isDone
                ? const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: AppColors.primaryGreen,
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Text(
            label,
            style: AppTypography.bodyLarge.copyWith(
              color: isDone ? AppColors.textPrimary : AppColors.textMuted,
              fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
