import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/calcuon_button.dart';
import '../controllers/calculator_controller.dart';

/// Standard calculator keypad — 4×5 grid.
///
/// Layout:
/// [ C ]  [ () ]  [ % ]  [ ÷ ]
/// [ 7 ]  [ 8 ]   [ 9 ]  [ × ]
/// [ 4 ]  [ 5 ]   [ 6 ]  [ − ]
/// [ 1 ]  [ 2 ]   [ 3 ]  [ + ]
/// [ 0      ]     [ . ]  [ = ]
class StandardKeypad extends StatelessWidget {
  const StandardKeypad({
    super.key,
    required this.controller,
    required this.state,
  });

  final CalculatorController controller;
  final CalculatorState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        children: [
          // Row 1: C, (), %, ÷
          Expanded(
            child: Row(
              children: [
                CalcuonButton(
                  label: state.expression.isEmpty ? 'AC' : 'C',
                  type: CalcButtonType.clear,
                  onTap: controller.clear,
                  onLongPress: controller.clearAll,
                ),
                CalcuonButton(
                  label: '( )',
                  type: CalcButtonType.function,
                  onTap: () => _handleParentheses(),
                ),
                CalcuonButton(
                  label: '%',
                  type: CalcButtonType.function,
                  onTap: controller.inputPercent,
                ),
                CalcuonButton(
                  label: '÷',
                  type: CalcButtonType.operator,
                  onTap: () => controller.inputOperator('/'),
                ),
              ],
            ),
          ),

          // Row 2: 7, 8, 9, ×
          Expanded(
            child: Row(
              children: [
                CalcuonButton(
                  label: '7',
                  onTap: () => controller.inputDigit('7'),
                ),
                CalcuonButton(
                  label: '8',
                  onTap: () => controller.inputDigit('8'),
                ),
                CalcuonButton(
                  label: '9',
                  onTap: () => controller.inputDigit('9'),
                ),
                CalcuonButton(
                  label: '×',
                  type: CalcButtonType.operator,
                  onTap: () => controller.inputOperator('*'),
                ),
              ],
            ),
          ),

          // Row 3: 4, 5, 6, −
          Expanded(
            child: Row(
              children: [
                CalcuonButton(
                  label: '4',
                  onTap: () => controller.inputDigit('4'),
                ),
                CalcuonButton(
                  label: '5',
                  onTap: () => controller.inputDigit('5'),
                ),
                CalcuonButton(
                  label: '6',
                  onTap: () => controller.inputDigit('6'),
                ),
                CalcuonButton(
                  label: '−',
                  type: CalcButtonType.operator,
                  onTap: () => controller.inputOperator('-'),
                ),
              ],
            ),
          ),

          // Row 4: 1, 2, 3, +
          Expanded(
            child: Row(
              children: [
                CalcuonButton(
                  label: '1',
                  onTap: () => controller.inputDigit('1'),
                ),
                CalcuonButton(
                  label: '2',
                  onTap: () => controller.inputDigit('2'),
                ),
                CalcuonButton(
                  label: '3',
                  onTap: () => controller.inputDigit('3'),
                ),
                CalcuonButton(
                  label: '+',
                  type: CalcButtonType.operator,
                  onTap: () => controller.inputOperator('+'),
                ),
              ],
            ),
          ),

          // Row 5: 0 (wide), ., =
          Expanded(
            child: Row(
              children: [
                CalcuonButton(
                  label: '0',
                  flex: 2,
                  onTap: () => controller.inputDigit('0'),
                ),
                CalcuonButton(
                  label: '.',
                  onTap: () => controller.inputDigit('.'),
                ),
                CalcuonButton(
                  label: '=',
                  type: CalcButtonType.action,
                  onTap: controller.evaluate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleParentheses() {
    final expr = state.expression;
    final open = expr.split('(').length - 1;
    final close = expr.split(')').length - 1;

    // Smart parentheses: if more opens than closes, close; otherwise open
    if (expr.isEmpty ||
        _isOperator(expr[expr.length - 1]) ||
        expr.endsWith('(') ||
        open <= close) {
      controller.inputOpenParen();
    } else {
      controller.inputCloseParen();
    }
  }

  bool _isOperator(String c) => '+-*/'.contains(c);
}
