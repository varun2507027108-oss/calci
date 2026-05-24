import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_radius.dart';

/// Calculator mode selector — sleek pill tab bar.
///
/// Switches between Standard, Scientific, and other modes
/// with a smooth sliding indicator animation.
class ModeSelector extends StatelessWidget {
  const ModeSelector({
    super.key,
    required this.modes,
    required this.selectedIndex,
    required this.onModeChanged,
  });

  final List<String> modes;
  final int selectedIndex;
  final ValueChanged<int> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : AppColors.lightSurfaceKeypad,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          width: 0.5,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / modes.length;

          return Stack(
            children: [
              // Sliding amber indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: tabWidth * selectedIndex,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.accentAmber.withValues(alpha: isDark ? 0.2 : 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: AppColors.accentAmber.withValues(alpha: 0.4),
                      width: 0.5,
                    ),
                  ),
                ),
              ),
              // Tab labels
              Row(
                children: List.generate(modes.length, (index) {
                  final isSelected = index == selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onModeChanged(index),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected
                                ? AppColors.accentAmber
                                : (isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors.lightTextTertiary),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          child: Text(modes[index]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
