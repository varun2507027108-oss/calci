import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/math/expression_parser.dart';
import '../../../../core/utils/formatters.dart';

/// Calculator state.
class CalculatorState {
  const CalculatorState({
    this.expression = '',
    this.result = '0',
    this.history = const [],
    this.memory = 0,
    this.hasMemory = false,
    this.isDegreeMode = true,
    this.isScientificMode = false,
    this.isSecondFunction = false,
    this.error = '',
    this.hasResult = false,
  });

  final String expression;
  final String result;
  final List<CalculationEntry> history;
  final double memory;
  final bool hasMemory;
  final bool isDegreeMode;
  final bool isScientificMode;
  final bool isSecondFunction;
  final String error;
  final bool hasResult;

  CalculatorState copyWith({
    String? expression,
    String? result,
    List<CalculationEntry>? history,
    double? memory,
    bool? hasMemory,
    bool? isDegreeMode,
    bool? isScientificMode,
    bool? isSecondFunction,
    String? error,
    bool? hasResult,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      history: history ?? this.history,
      memory: memory ?? this.memory,
      hasMemory: hasMemory ?? this.hasMemory,
      isDegreeMode: isDegreeMode ?? this.isDegreeMode,
      isScientificMode: isScientificMode ?? this.isScientificMode,
      isSecondFunction: isSecondFunction ?? this.isSecondFunction,
      error: error ?? this.error,
      hasResult: hasResult ?? this.hasResult,
    );
  }
}

/// A single calculation history entry.
class CalculationEntry {
  const CalculationEntry({
    required this.expression,
    required this.result,
    required this.timestamp,
    this.isFavorite = false,
  });

  final String expression;
  final String result;
  final DateTime timestamp;
  final bool isFavorite;

  Map<String, dynamic> toMap() => {
        'expression': expression,
        'result': result,
        'timestamp': timestamp.toIso8601String(),
        'isFavorite': isFavorite,
      };

  factory CalculationEntry.fromMap(Map<String, dynamic> map) {
    return CalculationEntry(
      expression: map['expression'] as String,
      result: map['result'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }
}

/// Calculator controller — handles all calculator operations.
final calculatorProvider =
    StateNotifierProvider<CalculatorController, CalculatorState>((ref) {
  return CalculatorController();
});

class CalculatorController extends StateNotifier<CalculatorState> {
  CalculatorController() : super(const CalculatorState()) {
    _loadHistory();
  }

  final _parser = ExpressionParser();

  // ─── INPUT HANDLING ─────────────────────────────────────────

  /// Append a digit or decimal point to the expression.
  void inputDigit(String digit) {
    // If we just got a result, start fresh with new digit
    if (state.hasResult && !_isOperator(digit)) {
      state = state.copyWith(
        expression: digit,
        result: '0',
        error: '',
        hasResult: false,
      );
      return;
    }

    state = state.copyWith(
      expression: state.expression + digit,
      error: '',
      hasResult: false,
    );
    _liveEvaluate();
  }

  /// Append an operator (+, -, ×, ÷).
  void inputOperator(String op) {
    String expr = state.expression;

    // If we have a result, continue from it
    if (state.hasResult && state.result != 'Error') {
      expr = state.result.replaceAll(',', '');
    }

    // Replace last operator if expression ends with one
    if (expr.isNotEmpty && _isOperator(expr[expr.length - 1])) {
      expr = expr.substring(0, expr.length - 1);
    }

    if (expr.isEmpty && op != '-') return;

    state = state.copyWith(
      expression: expr + op,
      error: '',
      hasResult: false,
    );
  }

  /// Append a scientific function (e.g., "sin(", "log(").
  void inputFunction(String func) {
    String expr = state.expression;

    if (state.hasResult) {
      // Apply function to result
      expr = '$func(${state.result.replaceAll(',', '')})';
      state = state.copyWith(expression: expr, hasResult: false, error: '');
      _liveEvaluate();
      return;
    }

    state = state.copyWith(
      expression: expr + '$func(',
      error: '',
      hasResult: false,
    );
  }

  /// Open parenthesis.
  void inputOpenParen() {
    state = state.copyWith(
      expression: '${state.expression}(',
      error: '',
      hasResult: false,
    );
  }

  /// Close parenthesis.
  void inputCloseParen() {
    // Only close if there's an unmatched open paren
    final open = state.expression.split('(').length - 1;
    final close = state.expression.split(')').length - 1;
    if (open > close) {
      state = state.copyWith(
        expression: '${state.expression})',
        error: '',
        hasResult: false,
      );
      _liveEvaluate();
    }
  }

  /// Toggle sign of current number or expression.
  void toggleSign() {
    if (state.expression.isEmpty) return;

    String expr = state.expression;
    if (expr.startsWith('-')) {
      expr = expr.substring(1);
    } else {
      expr = '-$expr';
    }

    state = state.copyWith(expression: expr, error: '');
    _liveEvaluate();
  }

  /// Input percentage.
  void inputPercent() {
    if (state.expression.isEmpty) return;

    state = state.copyWith(
      expression: '${state.expression}%',
      error: '',
    );
    _liveEvaluate();
  }

  // ─── EVALUATION ─────────────────────────────────────────────

  /// Evaluate the current expression and display the result.
  void evaluate() {
    if (state.expression.isEmpty) return;

    try {
      final rawResult = _parser.evaluate(
        state.expression,
        isDegreeMode: state.isDegreeMode,
      );
      final formatted = NumberFormatter.formatResult(rawResult);

      // Save to history
      final entry = CalculationEntry(
        expression: state.expression,
        result: formatted,
        timestamp: DateTime.now(),
      );
      final newHistory = [entry, ...state.history].take(200).toList();

      state = state.copyWith(
        result: formatted,
        history: newHistory,
        error: '',
        hasResult: true,
      );

      _saveHistory(entry);
    } on ExpressionError catch (e) {
      state = state.copyWith(
        error: e.message,
        result: 'Error',
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Invalid expression',
        result: 'Error',
      );
    }
  }

  /// Live evaluation as user types (preview result).
  void _liveEvaluate() {
    if (state.expression.isEmpty) {
      state = state.copyWith(result: '0');
      return;
    }

    try {
      // Auto-close parentheses for preview
      String expr = state.expression;
      final open = expr.split('(').length - 1;
      final close = expr.split(')').length - 1;
      for (int i = 0; i < open - close; i++) {
        expr += ')';
      }

      final rawResult = _parser.evaluate(
        expr,
        isDegreeMode: state.isDegreeMode,
      );
      final formatted = NumberFormatter.formatResult(rawResult);

      state = state.copyWith(result: formatted, error: '');
    } catch (_) {
      // Don't show errors during live evaluation — silently keep old result
    }
  }

  // ─── EDITING ────────────────────────────────────────────────

  /// Delete the last character (backspace / swipe-right gesture).
  void backspace() {
    if (state.expression.isEmpty) return;

    final newExpr = state.expression.substring(0, state.expression.length - 1);
    state = state.copyWith(
      expression: newExpr,
      error: '',
      hasResult: false,
    );
    _liveEvaluate();
  }

  /// Clear the current expression (C).
  void clear() {
    state = state.copyWith(
      expression: '',
      result: '0',
      error: '',
      hasResult: false,
    );
  }

  /// Clear all — expression + history (AC / long press C).
  void clearAll() {
    state = state.copyWith(
      expression: '',
      result: '0',
      error: '',
      hasResult: false,
    );
  }

  // ─── MEMORY ─────────────────────────────────────────────────

  void memoryAdd() {
    final val = double.tryParse(state.result.replaceAll(',', '')) ?? 0;
    state = state.copyWith(
      memory: state.memory + val,
      hasMemory: true,
    );
  }

  void memorySubtract() {
    final val = double.tryParse(state.result.replaceAll(',', '')) ?? 0;
    state = state.copyWith(
      memory: state.memory - val,
      hasMemory: true,
    );
  }

  void memoryRecall() {
    if (!state.hasMemory) return;
    final memStr = NumberFormatter.formatResult(state.memory).replaceAll(',', '');
    state = state.copyWith(
      expression: state.expression + memStr,
      error: '',
      hasResult: false,
    );
    _liveEvaluate();
  }

  void memoryClear() {
    state = state.copyWith(memory: 0, hasMemory: false);
  }

  // ─── MODE TOGGLES ──────────────────────────────────────────

  void toggleDegreeMode() {
    state = state.copyWith(isDegreeMode: !state.isDegreeMode);
  }

  void toggleScientificMode() {
    state = state.copyWith(isScientificMode: !state.isScientificMode);
  }

  void toggleSecondFunction() {
    state = state.copyWith(isSecondFunction: !state.isSecondFunction);
  }

  // ─── HISTORY ────────────────────────────────────────────────

  void useHistoryEntry(CalculationEntry entry) {
    state = state.copyWith(
      expression: entry.expression,
      result: entry.result,
      hasResult: true,
      error: '',
    );
  }

  void clearHistory() {
    state = state.copyWith(history: []);
    Hive.box('calculationHistory').clear();
  }

  // ─── PERSISTENCE ───────────────────────────────────────────

  void _loadHistory() {
    final box = Hive.box('calculationHistory');
    final entries = <CalculationEntry>[];
    for (int i = 0; i < box.length; i++) {
      final raw = box.getAt(i);
      if (raw is Map) {
        entries.add(CalculationEntry.fromMap(Map<String, dynamic>.from(raw)));
      }
    }
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    state = state.copyWith(history: entries.take(200).toList());
  }

  void _saveHistory(CalculationEntry entry) {
    final box = Hive.box('calculationHistory');
    box.add(entry.toMap());
    // Trim old entries
    if (box.length > 200) {
      for (int i = 0; i < box.length - 200; i++) {
        box.deleteAt(0);
      }
    }
  }

  // ─── HELPERS ────────────────────────────────────────────────

  bool _isOperator(String c) => '+-×÷*/'.contains(c);
}
