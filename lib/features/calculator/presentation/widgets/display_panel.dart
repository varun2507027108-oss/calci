import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_result.dart';
import '../../../../core/utils/formatters.dart';

/// Display panel — shows expression being typed and the result.
///
/// Top section: small expression text (mono font)
/// Bottom section: large animated result (display font)
/// Status bar: DEG/RAD indicator + memory indicator
class DisplayPanel extends StatelessWidget {
  const DisplayPanel({
    super.key,
    required this.expression,
    required this.result,
    required this.error,
    required this.hasMemory,
    required this.isDegreeMode,
  });

  final String expression;
  final String result;
  final String error;
  final bool hasMemory;
  final bool isDegreeMode;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.displayPadding,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Status indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (hasMemory) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentEmerald.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.accentEmerald.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    'M',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accentEmerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle)
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isDegreeMode ? 'DEG' : 'RAD',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Expression line
          if (expression.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                NumberFormatter.formatExpression(expression),
                style: AppTypography.expressionDisplay.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Result display
          AnimatedResult(
            value: error.isNotEmpty ? error : result,
            style: AppTypography.resultDisplay.copyWith(
              color: error.isNotEmpty
                  ? AppColors.accentTerracotta
                  : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              fontSize: _getAdaptiveFontSize(result),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  /// Shrink font size for very long results.
  double _getAdaptiveFontSize(String text) {
    final length = text.replaceAll(',', '').length;
    if (length <= 8) return 56;
    if (length <= 12) return 44;
    if (length <= 16) return 36;
    return 28;
  }
}
