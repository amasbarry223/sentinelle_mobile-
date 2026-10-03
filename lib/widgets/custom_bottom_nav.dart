import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CustomBottomNav extends StatefulWidget {
  final VoidCallback onAnalyzeTap;

  const CustomBottomNav({
    super.key,
    required this.onAnalyzeTap,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Continuous subtle radar breathing pulse on the central scanner button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onItemTap(int index, AppState appState) {
    HapticFeedback.lightImpact();
    appState.setNavIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentIndex = appState.currentNavIndex;

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12, top: 4),
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // Main Floating Dock Container
              Container(
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.cardBorder.withValues(alpha: 0.9),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Tab 0: Accueil
                    Expanded(
                      child: _buildTabItem(
                        index: 0,
                        currentIndex: currentIndex,
                        icon: Icons.grid_view_rounded,
                        activeIcon: Icons.grid_view_rounded,
                        label: 'Accueil',
                        onTap: () => _onItemTap(0, appState),
                      ),
                    ),

                    // Tab 1: Historique
                    Expanded(
                      child: _buildTabItem(
                        index: 1,
                        currentIndex: currentIndex,
                        icon: Icons.history_rounded,
                        activeIcon: Icons.history_rounded,
                        label: 'Historique',
                        badgeCount: appState.history.length,
                        onTap: () => _onItemTap(1, appState),
                      ),
                    ),

                    // Center Spacer for elevated Scanner button
                    const SizedBox(width: 72),

                    // Tab 3: Guide
                    Expanded(
                      child: _buildTabItem(
                        index: 3,
                        currentIndex: currentIndex,
                        icon: Icons.menu_book_rounded,
                        activeIcon: Icons.menu_book_rounded,
                        label: 'Guide',
                        onTap: () => _onItemTap(3, appState),
                      ),
                    ),

                    // Tab 4: Profil
                    Expanded(
                      child: _buildTabItem(
                        index: 4,
                        currentIndex: currentIndex,
                        icon: Icons.person_rounded,
                        activeIcon: Icons.person_rounded,
                        label: 'Profil',
                        onTap: () => _onItemTap(4, appState),
                      ),
                    ),
                  ],
                ),
              ),

              // Floating Central Scanner / Radar Action Button
              Positioned(
                top: -18,
                child: _buildCenterScannerButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    final isSelected = index == currentIndex;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Animated pill background for active state
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryGreen.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    size: 22,
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),

                // Subtle mini notification dot if items exist in history
                if (badgeCount != null && badgeCount > 0 && !isSelected)
                  Positioned(
                    right: 4,
                    top: 2,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.ochre,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTypography.bodySmall.copyWith(
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textSecondary.withValues(alpha: 0.8),
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                fontSize: 11,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterScannerButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onAnalyzeTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Animated Radar Wave Rings
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 62 * _pulseAnimation.value,
                    height: 62 * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.ochre.withValues(
                          alpha: (1.2 - _pulseAnimation.value).clamp(0.0, 0.4),
                        ),
                        width: 1.8,
                      ),
                    ),
                  );
                },
              ),

              // Outer white border ring for dock separation
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ochre.withValues(alpha: 0.35),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),

              // Primary Gradient Action Button
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE5A13B),
                      Color(0xFFC88A28),
                      Color(0xFFA16B19),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.radar_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Scanner',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.ochreDark,
              fontWeight: FontWeight.w800,
              fontSize: 10.5,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
