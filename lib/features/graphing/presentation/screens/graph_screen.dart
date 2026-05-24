import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/graph/graph_painter.dart';
import '../../../../core/widgets/glass_container.dart';

/// Graph plotting screen — interactive 2D graphing workspace.
///
/// Features:
/// - Pinch-to-zoom and pan gestures
/// - Multiple equations with color coding
/// - Real-time graph updates while typing
/// - Grid toggle, derivative toggle
/// - Equation list with add/remove
class GraphScreen extends ConsumerStatefulWidget {
  const GraphScreen({super.key});

  @override
  ConsumerState<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends ConsumerState<GraphScreen> {
  double _xMin = -10;
  double _xMax = 10;
  double _yMin = -10;
  double _yMax = 10;
  bool _showGrid = true;
  bool _showDerivative = false;

  final List<_EquationInput> _equations = [
    _EquationInput(expression: 'sin(x)', controller: TextEditingController(text: 'sin(x)')),
  ];

  // Gesture state
  Offset? _panStart;
  double? _scaleStart;

  @override
  void dispose() {
    for (final eq in _equations) {
      eq.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkSurfacePrimary
          : AppColors.lightSurfacePrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── TOOLBAR ──────────────────────────────────────
            _buildToolbar(isDark),

            // ── GRAPH CANVAS ─────────────────────────────────
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.lightSurfaceElevated,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorderSubtle
                            : AppColors.lightBorderSubtle,
                        width: 0.5,
                      ),
                    ),
                    child: GestureDetector(
                      onScaleStart: _onScaleStart,
                      onScaleUpdate: _onScaleUpdate,
                      onDoubleTap: _resetView,
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: GraphPainter(
                            equations: _buildGraphEquations(),
                            xMin: _xMin,
                            xMax: _xMax,
                            yMin: _yMin,
                            yMax: _yMax,
                            isDark: isDark,
                            showGrid: _showGrid,
                            showDerivative: _showDerivative,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── EQUATION INPUT AREA ──────────────────────────
            Expanded(
              flex: 3,
              child: _buildEquationPanel(isDark),
            ),

            SizedBox(height: AppSpacing.bottomNavHeight + bottomPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Text(
            'Graph',
            style: AppTypography.headlineLarge.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const Spacer(),
          _ToolbarButton(
            icon: Icons.grid_on_rounded,
            isActive: _showGrid,
            isDark: isDark,
            onTap: () => setState(() => _showGrid = !_showGrid),
            tooltip: 'Grid',
          ),
          const SizedBox(width: AppSpacing.sm),
          _ToolbarButton(
            icon: Icons.timeline_rounded,
            isActive: _showDerivative,
            isDark: isDark,
            onTap: () => setState(() => _showDerivative = !_showDerivative),
            tooltip: 'Derivative',
          ),
          const SizedBox(width: AppSpacing.sm),
          _ToolbarButton(
            icon: Icons.center_focus_strong_rounded,
            isActive: false,
            isDark: isDark,
            onTap: _resetView,
            tooltip: 'Reset',
          ),
        ],
      ),
    );
  }

  Widget _buildEquationPanel(bool isDark) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            itemCount: _equations.length,
            itemBuilder: (context, index) {
              final color = AppColors.graphPalette[index % AppColors.graphPalette.length];
              return _EquationCard(
                equation: _equations[index],
                color: color,
                isDark: isDark,
                onChanged: (_) => setState(() {}),
                onRemove: _equations.length > 1
                    ? () {
                        setState(() {
                          _equations[index].controller.dispose();
                          _equations.removeAt(index);
                        });
                      }
                    : null,
              );
            },
          ),
        ),
        // Add equation button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          child: GestureDetector(
            onTap: _addEquation,
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkButtonDefault
                    : AppColors.lightButtonDefault,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: AppColors.accentAmber,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Add equation',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.accentAmber,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── GESTURE HANDLING ──────────────────────────────────────

  void _onScaleStart(ScaleStartDetails details) {
    _panStart = details.focalPoint;
    _scaleStart = (_xMax - _xMin);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Pan
      if (_panStart != null) {
        final dx = (details.focalPoint.dx - _panStart!.dx) / 30;
        final dy = (details.focalPoint.dy - _panStart!.dy) / 30;
        final xShift = -dx * (_xMax - _xMin) / 10;
        final yShift = dy * (_yMax - _yMin) / 10;
        _xMin += xShift;
        _xMax += xShift;
        _yMin += yShift;
        _yMax += yShift;
        _panStart = details.focalPoint;
      }

      // Zoom
      if (details.scale != 1.0 && _scaleStart != null) {
        final scale = 1 / details.scale;
        final newRange = _scaleStart! * scale;
        final centerX = (_xMin + _xMax) / 2;
        final centerY = (_yMin + _yMax) / 2;
        _xMin = centerX - newRange / 2;
        _xMax = centerX + newRange / 2;
        _yMin = centerY - newRange / 2;
        _yMax = centerY + newRange / 2;
      }
    });
  }

  void _resetView() {
    setState(() {
      _xMin = -10;
      _xMax = 10;
      _yMin = -10;
      _yMax = 10;
    });
  }

  void _addEquation() {
    setState(() {
      _equations.add(_EquationInput(
        expression: '',
        controller: TextEditingController(),
      ));
    });
  }

  // ─── EQUATION BUILDING ─────────────────────────────────────

  List<GraphEquation> _buildGraphEquations() {
    final results = <GraphEquation>[];
    for (final eq in _equations) {
      final expr = eq.controller.text.trim();
      if (expr.isEmpty) continue;

      final evaluator = _buildEvaluator(expr);
      if (evaluator != null) {
        results.add(GraphEquation(
          expression: expr,
          evaluator: evaluator,
        ));
      }
    }
    return results;
  }

  double Function(double x)? _buildEvaluator(String expr) {
    // Simple expression evaluator for common functions
    expr = expr.toLowerCase().trim();

    // Remove "y=" prefix if present
    if (expr.startsWith('y=') || expr.startsWith('y =')) {
      expr = expr.substring(expr.indexOf('=') + 1).trim();
    }

    try {
      return (double x) {
        String e = expr;
        // Replace x with value
        e = e.replaceAll('x', '($x)');
        // Replace constants
        e = e.replaceAll('pi', '${math.pi}');
        e = e.replaceAll('e', '${math.e}');

        return _evaluateSimple(e);
      };
    } catch (_) {
      return null;
    }
  }

  double _evaluateSimple(String expr) {
    // This delegates to the expression parser for safety
    // For now, we use Dart's math functions directly
    try {
      // Handle common patterns
      expr = expr.trim();

      // Try direct parsing for simple expressions
      final parser = _SimpleParser(expr);
      return parser.parse();
    } catch (_) {
      return double.nan;
    }
  }
}

// ─── SUPPORTING WIDGETS ─────────────────────────────────────

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.isActive,
    required this.isDark,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.accentAmber.withValues(alpha: 0.15)
              : (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceKeypad),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: isActive
                ? AppColors.accentAmber.withValues(alpha: 0.3)
                : (isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle),
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive
              ? AppColors.accentAmber
              : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
      ),
    );
  }
}

class _EquationCard extends StatelessWidget {
  const _EquationCard({
    required this.equation,
    required this.color,
    required this.isDark,
    required this.onChanged,
    this.onRemove,
  });

  final _EquationInput equation;
  final Color color;
  final bool isDark;
  final ValueChanged<String> onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Equation prefix
          Text(
            'y = ',
            style: AppTypography.monoMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 14,
            ),
          ),

          // Input field
          Expanded(
            child: TextField(
              controller: equation.controller,
              onChanged: onChanged,
              style: AppTypography.monoMedium.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'x^2 + 1',
              ),
            ),
          ),

          // Remove button
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              ),
            ),
        ],
      ),
    );
  }
}

class _EquationInput {
  _EquationInput({required this.expression, required this.controller});
  String expression;
  final TextEditingController controller;
}

// ─── SIMPLE EXPRESSION PARSER FOR GRAPHS ──────────────────────

class _SimpleParser {
  _SimpleParser(this.input);
  final String input;
  int pos = 0;

  double parse() {
    final result = _parseExpression();
    return result;
  }

  double _parseExpression() {
    double result = _parseTerm();
    while (pos < input.length) {
      if (_match('+')) {
        result += _parseTerm();
      } else if (_match('-')) {
        result -= _parseTerm();
      } else {
        break;
      }
    }
    return result;
  }

  double _parseTerm() {
    double result = _parsePower();
    while (pos < input.length) {
      if (_match('*')) {
        result *= _parsePower();
      } else if (_match('/')) {
        final d = _parsePower();
        if (d == 0) return double.nan;
        result /= d;
      } else {
        break;
      }
    }
    return result;
  }

  double _parsePower() {
    double base = _parseUnary();
    if (_match('^')) {
      final exp = _parseUnary();
      return math.pow(base, exp).toDouble();
    }
    return base;
  }

  double _parseUnary() {
    if (_match('-')) return -_parsePrimary();
    if (_match('+')) return _parsePrimary();
    return _parsePrimary();
  }

  double _parsePrimary() {
    _skipSpaces();

    // Functions
    for (final fn in ['sin', 'cos', 'tan', 'log', 'ln', 'sqrt', 'abs', 'exp']) {
      if (_matchWord(fn)) {
        _expect('(');
        final arg = _parseExpression();
        _expect(')');
        return _applyFn(fn, arg);
      }
    }

    // Parentheses
    if (_match('(')) {
      final result = _parseExpression();
      _expect(')');
      return result;
    }

    // Number
    return _parseNumber();
  }

  double _applyFn(String fn, double arg) {
    switch (fn) {
      case 'sin': return math.sin(arg);
      case 'cos': return math.cos(arg);
      case 'tan': return math.tan(arg);
      case 'log': return math.log(arg) / math.ln10;
      case 'ln': return math.log(arg);
      case 'sqrt': return math.sqrt(arg);
      case 'abs': return arg.abs();
      case 'exp': return math.exp(arg);
      default: return double.nan;
    }
  }

  double _parseNumber() {
    _skipSpaces();
    final start = pos;
    while (pos < input.length && (_isDigit(input[pos]) || input[pos] == '.')) {
      pos++;
    }
    if (pos == start) return double.nan;
    return double.tryParse(input.substring(start, pos)) ?? double.nan;
  }

  bool _match(String c) {
    _skipSpaces();
    if (pos < input.length && input[pos] == c) {
      pos++;
      return true;
    }
    return false;
  }

  bool _matchWord(String word) {
    _skipSpaces();
    if (pos + word.length <= input.length &&
        input.substring(pos, pos + word.length) == word) {
      pos += word.length;
      return true;
    }
    return false;
  }

  void _expect(String c) {
    if (!_match(c)) {
      // Silently continue for robustness
    }
  }

  void _skipSpaces() {
    while (pos < input.length && input[pos] == ' ') pos++;
  }

  bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
}
