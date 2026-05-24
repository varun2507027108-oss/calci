import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// App shell with frosted glass bottom navigation bar.
///
/// 5 tabs: Calculator, Graph, Converter, Formulas, Settings.
/// Bottom bar uses BackdropFilter for glassmorphism effect.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _TabItem('/calculator', Icons.calculate_outlined, Icons.calculate_rounded, 'Calc'),
    _TabItem('/graphing', Icons.show_chart_outlined, Icons.show_chart_rounded, 'Graph'),
    _TabItem('/converter', Icons.swap_horiz_outlined, Icons.swap_horiz_rounded, 'Convert'),
    _TabItem('/formulas', Icons.functions_outlined, Icons.functions_rounded, 'Formulas'),
    _TabItem('/settings', Icons.tune_outlined, Icons.tune_rounded, 'Settings'),
  ];

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = _getCurrentIndex(context);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: AppSpacing.bottomNavHeight + bottomPadding,
            padding: EdgeInsets.only(bottom: bottomPadding),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfacePrimary.withValues(alpha: 0.85)
                  : AppColors.lightSurfacePrimary.withValues(alpha: 0.9),
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                final isActive = index == currentIndex;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (index != currentIndex) {
                        context.go(tab.path);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.accentAmber.withValues(alpha: isDark ? 0.15 : 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isActive ? tab.activeIcon : tab.icon,
                            color: isActive
                                ? AppColors.accentAmber
                                : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontFamily: AppTypography.bodyFont,
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            color: isActive
                                ? AppColors.accentAmber
                                : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem(this.path, this.icon, this.activeIcon, this.label);
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
