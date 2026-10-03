import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum RiskLevel {
  faible,
  modere,
  eleve,
  critique,
}

extension RiskLevelExtension on RiskLevel {
  String get label {
    switch (this) {
      case RiskLevel.faible:
        return 'Risque faible';
      case RiskLevel.modere:
        return 'Risque modéré';
      case RiskLevel.eleve:
        return 'Risque élevé';
      case RiskLevel.critique:
        return 'Risque critique';
    }
  }

  Color get color {
    switch (this) {
      case RiskLevel.faible:
        return AppColors.riskLow;
      case RiskLevel.modere:
        return AppColors.riskModerate;
      case RiskLevel.eleve:
        return AppColors.riskElevated;
      case RiskLevel.critique:
        return AppColors.riskCritical;
    }
  }

  Color get bgColor {
    switch (this) {
      case RiskLevel.faible:
        return AppColors.riskLowBg;
      case RiskLevel.modere:
        return AppColors.riskModerateBg;
      case RiskLevel.eleve:
        return AppColors.riskElevatedBg;
      case RiskLevel.critique:
        return AppColors.riskCriticalBg;
    }
  }

  Color get borderColor {
    switch (this) {
      case RiskLevel.faible:
        return AppColors.riskLowBorder;
      case RiskLevel.modere:
        return AppColors.riskModerateBorder;
      case RiskLevel.eleve:
        return AppColors.riskElevatedBorder;
      case RiskLevel.critique:
        return AppColors.riskCriticalBorder;
    }
  }

  IconData get icon {
    switch (this) {
      case RiskLevel.faible:
        return Icons.verified_user_outlined;
      case RiskLevel.modere:
        return Icons.warning_amber_rounded;
      case RiskLevel.eleve:
        return Icons.warning_rounded;
      case RiskLevel.critique:
        return Icons.front_hand_rounded;
    }
  }
}
