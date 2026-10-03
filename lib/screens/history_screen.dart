import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/history_item.dart';
import '../models/risk_level.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/privacy_banner.dart';
import 'analyze/result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final items = appState.filteredHistory;

    // Group items by dateGroup
    final Map<String, List<HistoryItem>> grouped = {};
    for (final it in items) {
      grouped.putIfAbsent(it.dateGroup, () => []).add(it);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Historique',
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 24, color: Color(0xFFDC2626)),
                    onPressed: () => _confirmClearHistory(context, appState),
                  ),
                ],
              ),
            ),

            // Privacy Banner
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: PrivacyBanner(text: "Visible uniquement sur ce téléphone."),
            ),
            const SizedBox(height: 14),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder, width: 1.2),
                ),
                child: TextField(
                  onChanged: (q) => appState.setHistorySearchQuery(q),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
                    hintText: 'Rechercher un message, un numéro...',
                    hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Filter Chips Rows
            _buildFilterChips(context, appState),
            const SizedBox(height: 10),

            // List of items
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_toggle_off_rounded, size: 48, color: AppColors.textMuted.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'Aucun historique trouvé',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      children: grouped.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 14, bottom: 10),
                              child: Text(
                                entry.key,
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            ...entry.value.map((item) => _buildHistoryCard(context, item, appState)),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, AppState state) {
    final typeFilters = ['Tous', 'SMS', 'Lien', 'Numéro', 'MM'];
    final riskFilters = ['Tous', 'Faible', 'Modéré', 'Élevé', 'Critique'];

    return Column(
      children: [
        // Row 1: Type
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: typeFilters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final val = typeFilters[i];
              final isSelected = state.historyTypeFilter == val;
              return GestureDetector(
                onTap: () => state.setHistoryTypeFilter(val),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryGreen : AppColors.cardBorder,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    val,
                    style: AppTypography.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // Row 2: Risk
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: riskFilters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final val = riskFilters[i];
              final isSelected = state.historyRiskFilter == val;

              Color dotColor = Colors.transparent;
              if (val == 'Faible') dotColor = AppColors.riskLow;
              if (val == 'Modéré') dotColor = AppColors.riskModerate;
              if (val == 'Élevé') dotColor = AppColors.riskElevated;
              if (val == 'Critique') dotColor = AppColors.riskCritical;

              return GestureDetector(
                onTap: () => state.setHistoryRiskFilter(val),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryGreen : AppColors.cardBorder,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (dotColor != Colors.transparent) ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        val,
                        style: AppTypography.bodySmall.copyWith(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(BuildContext context, HistoryItem item, AppState state) {
    IconData leadingIcon = Icons.chat_bubble_outline_rounded;
    if (item.type == 'Lien') leadingIcon = Icons.link_rounded;
    if (item.type == 'Numéro') leadingIcon = Icons.phone_outlined;
    if (item.type == 'MM' || item.type == 'Mobile Money') leadingIcon = Icons.account_balance_wallet_outlined;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ResultScreen(result: item.result),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: Row(
            children: [
              // Leading Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF8F2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(leadingIcon, color: AppColors.primaryGreen, size: 22),
              ),
              const SizedBox(width: 14),

              // Content & Risk Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.maskedText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.riskLevel.bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: item.riskLevel.borderColor, width: 1.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item.riskLevel.icon, size: 12, color: item.riskLevel.color),
                          const SizedBox(width: 4),
                          Text(
                            '${item.riskLevel.label} · ${item.score}/100',
                            style: AppTypography.badgeText.copyWith(
                              color: item.riskLevel.color,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Delete button
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textMuted, size: 20),
                onPressed: () => state.deleteHistoryItem(item.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmClearHistory(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Effacer l\'historique ?'),
        content: const Text('Toutes les analyses enregistrées sur cet appareil seront définitivement supprimées.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              state.clearAllHistory();
              Navigator.of(ctx).pop();
            },
            child: const Text('Effacer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
