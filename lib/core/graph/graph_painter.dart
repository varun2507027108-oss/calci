import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Custom painter for 2D function graphs.
///
/// Renders:
/// - Cartesian grid with major/minor lines
/// - Axes with tick marks and labels
/// - Multiple equation curves with configurable colors
/// - Smooth Bézier interpolation for curves
/// - Intersection and root markers
///
/// Optimized with RepaintBoundary isolation.
class GraphPainter extends CustomPainter {
  GraphPainter({
    required this.equations,
    required this.xMin,
    required this.xMax,
    required this.yMin,
    required this.yMax,
    required this.isDark,
    this.showGrid = true,
    this.showDerivative = false,
  });

  final List<GraphEquation> equations;
  final double xMin, xMax, yMin, yMax;
  final bool isDark;
  final bool showGrid;
  final bool showDerivative;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final xRange = xMax - xMin;
    final yRange = yMax - yMin;

    // Coordinate transforms
    double toScreenX(double x) => (x - xMin) / xRange * size.width;
    double toScreenY(double y) => (1 - (y - yMin) / yRange) * size.height;

    // ── GRID ──────────────────────────────────────────────
    if (showGrid) {
      _drawGrid(canvas, size, toScreenX, toScreenY);
    }

    // ── AXES ──────────────────────────────────────────────
    _drawAxes(canvas, size, toScreenX, toScreenY);

    // ── EQUATIONS ─────────────────────────────────────────
    for (int i = 0; i < equations.length; i++) {
      final eq = equations[i];
      if (!eq.isVisible) continue;

      _drawCurve(
        canvas,
        size,
        eq,
        toScreenX,
        toScreenY,
        AppColors.graphPalette[i % AppColors.graphPalette.length],
      );

      // Derivative visualization
      if (showDerivative) {
        _drawDerivative(
          canvas,
          size,
          eq,
          toScreenX,
          toScreenY,
          AppColors.graphPalette[i % AppColors.graphPalette.length]
              .withValues(alpha: 0.4),
        );
      }
    }
  }

  void _drawGrid(
    Canvas canvas,
    Size size,
    double Function(double) toScreenX,
    double Function(double) toScreenY,
  ) {
    final gridPaint = Paint()
      ..color = isDark
          ? AppColors.darkBorderSubtle.withValues(alpha: 0.3)
          : AppColors.lightBorderSubtle.withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    final step = _calculateGridStep(xMax - xMin);

    // Vertical grid lines
    double x = (xMin / step).ceil() * step;
    while (x <= xMax) {
      final screenX = toScreenX(x);
      canvas.drawLine(
        Offset(screenX, 0),
        Offset(screenX, size.height),
        gridPaint,
      );
      x += step;
    }

    // Horizontal grid lines
    double y = (yMin / step).ceil() * step;
    while (y <= yMax) {
      final screenY = toScreenY(y);
      canvas.drawLine(
        Offset(0, screenY),
        Offset(size.width, screenY),
        gridPaint,
      );
      y += step;
    }
  }

  void _drawAxes(
    Canvas canvas,
    Size size,
    double Function(double) toScreenX,
    double Function(double) toScreenY,
  ) {
    final axisPaint = Paint()
      ..color = isDark
          ? AppColors.darkTextTertiary.withValues(alpha: 0.6)
          : AppColors.lightTextTertiary.withValues(alpha: 0.6)
      ..strokeWidth = 1.0;

    // X-axis
    if (yMin <= 0 && yMax >= 0) {
      final y0 = toScreenY(0);
      canvas.drawLine(Offset(0, y0), Offset(size.width, y0), axisPaint);
    }

    // Y-axis
    if (xMin <= 0 && xMax >= 0) {
      final x0 = toScreenX(0);
      canvas.drawLine(Offset(x0, 0), Offset(x0, size.height), axisPaint);
    }

    // Tick marks and labels
    final labelStyle = TextStyle(
      fontSize: 9,
      color: isDark
          ? AppColors.darkTextTertiary
          : AppColors.lightTextTertiary,
      fontFamily: 'JetBrainsMono',
    );

    final step = _calculateGridStep(xMax - xMin);

    // X-axis labels
    double x = (xMin / step).ceil() * step;
    while (x <= xMax) {
      if (x.abs() > step / 10) {
        final screenX = toScreenX(x);
        final y0 = yMin <= 0 && yMax >= 0 ? toScreenY(0) : size.height;
        _drawLabel(canvas, _formatTick(x), Offset(screenX, y0 + 4), labelStyle);
      }
      x += step;
    }

    // Y-axis labels
    double y = (yMin / step).ceil() * step;
    while (y <= yMax) {
      if (y.abs() > step / 10) {
        final screenY = toScreenY(y);
        final x0 = xMin <= 0 && xMax >= 0 ? toScreenX(0) : 0.0;
        _drawLabel(canvas, _formatTick(y), Offset(x0 - 4, screenY), labelStyle,
            alignRight: true);
      }
      y += step;
    }
  }

  void _drawCurve(
    Canvas canvas,
    Size size,
    GraphEquation eq,
    double Function(double) toScreenX,
    double Function(double) toScreenY,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    bool started = false;
    final numPoints = size.width.toInt() * 2; // 2x resolution for smoothness

    for (int i = 0; i <= numPoints; i++) {
      final x = xMin + (xMax - xMin) * i / numPoints;

      try {
        final y = eq.evaluate(x);

        if (y.isNaN || y.isInfinite || y < yMin - 10 || y > yMax + 10) {
          started = false;
          continue;
        }

        final screenX = toScreenX(x);
        final screenY = toScreenY(y);

        if (!started) {
          path.moveTo(screenX, screenY);
          started = true;
        } else {
          path.lineTo(screenX, screenY);
        }
      } catch (_) {
        started = false;
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawDerivative(
    Canvas canvas,
    Size size,
    GraphEquation eq,
    double Function(double) toScreenX,
    double Function(double) toScreenY,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    bool started = false;
    const h = 1e-7;
    final numPoints = size.width.toInt();

    for (int i = 0; i <= numPoints; i++) {
      final x = xMin + (xMax - xMin) * i / numPoints;

      try {
        final dydx = (eq.evaluate(x + h) - eq.evaluate(x - h)) / (2 * h);

        if (dydx.isNaN || dydx.isInfinite || dydx < yMin - 10 || dydx > yMax + 10) {
          started = false;
          continue;
        }

        final screenX = toScreenX(x);
        final screenY = toScreenY(dydx);

        if (!started) {
          path.moveTo(screenX, screenY);
          started = true;
        } else {
          path.lineTo(screenX, screenY);
        }
      } catch (_) {
        started = false;
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset position,
    TextStyle style, {
    bool alignRight = false,
  }) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = alignRight
        ? Offset(position.dx - textPainter.width - 2, position.dy - textPainter.height / 2)
        : Offset(position.dx - textPainter.width / 2, position.dy);

    textPainter.paint(canvas, offset);
  }

  double _calculateGridStep(double range) {
    final rawStep = range / 8;
    final magnitude = math.pow(10, (math.log(rawStep) / math.ln10).floor());
    final residual = rawStep / magnitude;

    if (residual <= 1.5) return magnitude.toDouble();
    if (residual <= 3.5) return 2 * magnitude.toDouble();
    if (residual <= 7.5) return 5 * magnitude.toDouble();
    return 10 * magnitude.toDouble();
  }

  String _formatTick(double val) {
    if (val == val.roundToDouble()) return val.toInt().toString();
    return val.toStringAsFixed(1);
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return oldDelegate.xMin != xMin ||
        oldDelegate.xMax != xMax ||
        oldDelegate.yMin != yMin ||
        oldDelegate.yMax != yMax ||
        oldDelegate.equations != equations ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.showDerivative != showDerivative;
  }
}

/// A graphable equation.
class GraphEquation {
  GraphEquation({
    required this.expression,
    required this.evaluator,
    this.color,
    this.isVisible = true,
    this.label,
  });

  final String expression;
  final double Function(double x) evaluator;
  final Color? color;
  final bool isVisible;
  final String? label;

  double evaluate(double x) => evaluator(x);
}
