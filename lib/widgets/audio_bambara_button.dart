import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AudioBambaraButton extends StatelessWidget {
  final String speechText;
  final bool fullWidth;
  final String? customLabel;

  const AudioBambaraButton({
    super.key,
    required this.speechText,
    this.fullWidth = false,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isPlaying = appState.isAudioPlaying && appState.currentlyPlayingText == speechText;

    if (fullWidth || customLabel != null) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.audioButtonBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.audioButtonBorder, width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _buildIconBadge(isPlaying),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                customLabel ?? "Écouter en bambara (Bamanankan)",
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.audioButtonText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () => appState.playBambaraAudio(speechText, context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.audioButtonBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.audioButtonBorder, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPlaying ? Icons.graphic_eq : Icons.volume_up_outlined,
              size: 16,
              color: AppColors.audioButtonText,
            ),
            const SizedBox(width: 6),
            Text(
              "BM",
              style: AppTypography.badgeText.copyWith(
                color: AppColors.audioButtonText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBadge(bool isPlaying) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.audioButtonBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPlaying ? Icons.graphic_eq : Icons.volume_up_outlined,
            size: 16,
            color: AppColors.audioButtonText,
          ),
          const SizedBox(width: 4),
          Text(
            "BM",
            style: AppTypography.badgeText.copyWith(
              color: AppColors.audioButtonText,
            ),
          ),
        ],
      ),
    );
  }
}
