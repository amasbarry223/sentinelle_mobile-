import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import 'analyze/analyze_screen.dart';
import 'guide/guide_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _openAnalyzeModal(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AnalyzeScreen(initialTabIndex: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentIndex = appState.currentNavIndex;

    // List of screens corresponding to bottom nav
    final screens = [
      HomeScreen(onOpenAnalyze: () => _openAnalyzeModal(context)),
      const HistoryScreen(),
      HomeScreen(onOpenAnalyze: () => _openAnalyzeModal(context)), // Fallback for center index
      const GuideScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        onAnalyzeTap: () => _openAnalyzeModal(context),
      ),
    );
  }
}
