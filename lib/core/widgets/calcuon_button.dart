import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

/// The type of calculator button — determines color, size, and typography.
enum CalcButtonType {
  digit,       // 0-9, .
  operator,    // +, -, ×, ÷
  action,      // = (primary amber)
  function,    // %, ±, brackets
  clear,       // C, AC (terracotta accent)
  scientific,  // sin, cos, log, etc.
  memory,      // M+, M-, MR, MC
}

/// Premium calculator button with tactile feedback.
///
/// Features:
/// - 80ms scale animation on press (simulates physical depression)
/// - Haptic feedback (light impact)
/// - Subtle inner shadow for depth
/// - Top-edge chamfer highlight
/// - Different visual treatments per button type
class CalcuonButton extends StatefulWidget {
  const CalcuonButton({
    super.key,
    required this.label,
    required this.onTap,
    this.type = CalcButtonType.digit,
    this.icon,
    this.flex = 1,
    this.onLongPress,
    this.enabled = true,
    this.superscript,
  });

  final String label;
  final VoidCallback onTap;
  final CalcButtonType type;
  final IconData? icon;
  final int flex;
  final VoidCallback? onLongPress;
  final bool enabled;
  final String? superscript;

  @override
  State<CalcuonButton> createState() => _CalcuonButtonState();
}

class _CalcuonButtonState extends State<CalcuonButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (!widget.enabled) return;
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails _) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleTap() {
    if (!widget.enabled) return;
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getColors(isDark);

    return Expanded(
      flex: widget.flex,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: _handleTap,
          onLongPress: widget.onLongPress,
          child: Container(
            height: 64,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(AppRadius.button),
              boxShadow: isDark
                  ? AppShadows.darkButtonHighlight
                  : AppShadows.lightButtonHighlight,
              border: Border.all(
                color: colors.border,
                width: 0.5,
              ),
            ),
            child: Center(
              child: widget.icon != null
                  ? Icon(widget.icon, color: colors.foreground, size: 22)
                  : _buildLabel(colors),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(_ButtonColors colors) {
    if (widget.superscript != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: _getTextStyle().copyWith(color: colors.foreground),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              widget.superscript!,
              style: TextStyle(
                fontFamily: AppTypography.bodyFont,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: colors.foreground.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      );
    }

    return Text(
      widget.label,
      style: _getTextStyle().copyWith(color: colors.foreground),
      maxLines: 1,
    );
  }

  TextStyle _getTextStyle() {
    switch (widget.type) {
      case CalcButtonType.digit:
        return AppTypography.buttonText;
      case CalcButtonType.operator:
        return AppTypography.operatorText;
      case CalcButtonType.action:
        return AppTypography.operatorText;
      case CalcButtonType.function:
        return AppTypography.buttonTextSmall;
      case CalcButtonType.clear:
        return AppTypography.buttonTextSmall.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        );
      case CalcButtonType.scientific:
        return AppTypography.buttonTextSmall;
      case CalcButtonType.memory:
        return AppTypography.buttonTextSmall.copyWith(fontSize: 12);
    }
  }

  _ButtonColors _getColors(bool isDark) {
    switch (widget.type) {
      case CalcButtonType.digit:
        return _ButtonColors(
          background: isDark ? AppColors.darkButtonDefault : AppColors.lightButtonDefault,
          foreground: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          border: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
        );
      case CalcButtonType.operator:
        return _ButtonColors(
          background: isDark ? AppColors.darkButtonOperator : AppColors.lightButtonOperator,
          foreground: AppColors.accentAmber,
          border: isDark ? AppColors.darkBorderAccent : AppColors.lightBorderAccent,
        );
      case CalcButtonType.action:
        return _ButtonColors(
          background: isDark ? AppColors.darkButtonAction : AppColors.lightButtonAction,
          foreground: isDark ? AppColors.darkSurfacePrimary : AppColors.lightSurfaceElevated,
          border: isDark ? AppColors.accentAmberLight : AppColors.accentAmberDark,
        );
      case CalcButtonType.function:
        return _ButtonColors(
          background: isDark ? AppColors.darkButtonOperator : AppColors.lightButtonOperator,
          foreground: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          border: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
        );
      case CalcButtonType.clear:
        return _ButtonColors(
          background: isDark ? AppColors.darkButtonOperator : AppColors.lightButtonOperator,
          foreground: AppColors.accentTerracotta,
          border: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
        );
      case CalcButtonType.scientific:
        return _ButtonColors(
          background: isDark ? AppColors.darkButtonScientific : AppColors.lightButtonScientific,
          foreground: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          border: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
        );
      case CalcButtonType.memory:
        return _ButtonColors(
          background: isDark ? AppColors.darkButtonScientific : AppColors.lightButtonScientific,
          foreground: AppColors.accentEmerald,
          border: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
        );
    }
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
