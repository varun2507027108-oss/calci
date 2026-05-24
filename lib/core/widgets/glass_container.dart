import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Frosted glass container — the signature Calcuon surface.
///
/// Uses BackdropFilter for real-time blur with semi-transparent fill
/// and a subtle luminous border gradient. GPU-accelerated via Impeller.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.margin,
    this.blur,
    this.opacity,
    this.borderColor,
    this.width,
    this.height,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? blur;
  final double? opacity;
  final Color? borderColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBlur = blur ?? AppColors.glassBlur;
    final effectiveOpacity = opacity ?? AppColors.glassOpacity;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppRadius.card);

    final fillColor = isDark
        ? AppColors.darkSurfaceGlass.withValues(alpha: effectiveOpacity)
        : AppColors.lightSurfaceGlass.withValues(alpha: effectiveOpacity);

    final effectiveBorderColor = borderColor ??
        (isDark
            ? AppColors.darkBorderSubtle.withValues(alpha: 0.5)
            : AppColors.lightBorderSubtle.withValues(alpha: 0.5));

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlur,
            sigmaY: effectiveBlur,
          ),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: effectiveBorderRadius,
              border: Border.all(
                color: effectiveBorderColor,
                width: 0.5,
              ),
              // Subtle top-edge highlight for depth
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3],
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
