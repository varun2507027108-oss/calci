import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

/// Animated result display — digits roll/ticker into place.
///
/// When the result value changes, each character animates smoothly
/// to create a slot-machine-like rolling effect. Falls back to
/// instant display when reduceMotion is enabled.
class AnimatedResult extends StatelessWidget {
  const AnimatedResult({
    super.key,
    required this.value,
    this.style,
    this.textAlign = TextAlign.right,
    this.maxLines = 1,
  });

  final String value;
  final TextStyle? style;
  final TextAlign textAlign;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ??
        AppTypography.resultDisplay.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );

    final reduceMotion = MediaQuery.of(context).accessibleNavigation;

    if (reduceMotion) {
      return _StaticDisplay(
        value: value,
        style: effectiveStyle,
        textAlign: textAlign,
      );
    }

    return _AnimatedDisplay(
      value: value,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class _StaticDisplay extends StatelessWidget {
  const _StaticDisplay({
    required this.value,
    required this.style,
    required this.textAlign,
  });

  final String value;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: textAlign == TextAlign.right
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Text(
        value,
        style: style,
        textAlign: textAlign,
        maxLines: 1,
      ),
    );
  }
}

class _AnimatedDisplay extends StatefulWidget {
  const _AnimatedDisplay({
    required this.value,
    required this.style,
    required this.textAlign,
    required this.maxLines,
  });

  final String value;
  final TextStyle style;
  final TextAlign textAlign;
  final int maxLines;

  @override
  State<_AnimatedDisplay> createState() => _AnimatedDisplayState();
}

class _AnimatedDisplayState extends State<_AnimatedDisplay> {
  String _previousValue = '';
  String _currentValue = '';

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant _AnimatedDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _currentValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: widget.textAlign == TextAlign.right
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          // Subtle slide-up transition for new values
          final slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ));

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },
        child: Text(
          _currentValue,
          key: ValueKey(_currentValue),
          style: widget.style,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
        ),
      ),
    );
  }
}
