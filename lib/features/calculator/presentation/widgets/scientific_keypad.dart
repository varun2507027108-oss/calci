import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/calcuon_button.dart';
import '../controllers/calculator_controller.dart';

/// Scientific calculator keypad — full function layout.
///
/// Adds scientific function rows above the standard keypad grid.
/// Supports 2nd function toggle for inverse trig, etc.
class ScientificKeypad extends StatelessWidget {
  const ScientificKeypad({
    super.key,
    required this.controller,
    required this.state,
  });

  final CalculatorController controller;
  final CalculatorState state;

  @override
  Widget build(BuildContext context) {
    final is2nd = state.isSecondFunction;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        children: [
          // Row 1: Scientific functions
          Expanded(
            child: Row(
              children: [
                CalcuonButton(
                  label: '2nd',
                  type: is2nd ? CalcButtonType.memory : CalcButtonType.scientific,
                  onTap: controller.toggleSecondFunction,
                ),
                CalcuonButton(
                  label: 'x²',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputDigit('^2'),
                ),
                CalcuonButton(
                  label: 'xⁿ',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputDigit('^'),
                ),
                CalcuonButton(
                  label: is2nd ? 'eˣ' : '10ˣ',
                  type: CalcButtonType.scientific,
                  onTap: () => is2nd
                      ? controller.inputFunction('exp')
                      : controller.inputDigit('10^'),
                ),
                CalcuonButton(
                  label: is2nd ? 'RAD' : 'DEG',
                  type: CalcButtonType.scientific,
                  onTap: controller.toggleDegreeMode,
                ),
              ],
            ),
          ),

          // Row 2: Trig functions
          Expanded(
            child: Row(
              children: [
                CalcuonButton(
                  label: is2nd ? 'sin⁻¹' : 'sin',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputFunction(is2nd ? 'asin' : 'sin'),
                ),
                CalcuonButton(
                  label: is2nd ? 'cos⁻¹' : 'cos',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputFunction(is2nd ? 'acos' : 'cos'),
                ),
                CalcuonButton(
                  label: is2nd ? 'tan⁻¹' : 'tan',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputFunction(is2nd ? 'atan' : 'tan'),
                ),
                CalcuonButton(
                  label: is2nd ? 'sinh' : 'ln',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputFunction(is2nd ? 'sinh' : 'ln'),
                ),
                CalcuonButton(
                  label: is2nd ? 'cosh' : 'log',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputFunction(is2nd ? 'cosh' : 'log'),
                ),
              ],
            ),
          ),

          // Row 3: Additional functions
          Expanded(
            child: Row(
              children: [
                CalcuonButton(
                  label: is2nd ? '∛' : '√',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputFunction(is2nd ? 'cbrt' : 'sqrt'),
                ),
                CalcuonButton(
                  label: 'n!',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputFunction('fact'),
                ),
                CalcuonButton(
                  label: 'π',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputDigit('π'),
                ),
                CalcuonButton(
                  label: 'e',
                  type: CalcButtonType.scientific,
                  onTap: () => controller.inputDigit('e'),
                ),
                CalcuonButton(
                  label: '±',
                  type: CalcButtonType.scientific,
                  onTap: controller.toggleSign,
                ),
              ],
            ),
          ),

          // Row 4: Memory + standard ops
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
                // Backspace
                CalcuonButton(
                  label: '⌫',
                  type: CalcButtonType.function,
                  icon: Icons.backspace_outlined,
                  onTap: controller.backspace,
                ),
              ],
            ),
          ),

          // Row 5: 7, 8, 9, ×, M+
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
                CalcuonButton(
                  label: 'M+',
                  type: CalcButtonType.memory,
                  onTap: controller.memoryAdd,
                ),
              ],
            ),
          ),

          // Row 6: 4, 5, 6, −, M−
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
                CalcuonButton(
                  label: 'M−',
                  type: CalcButtonType.memory,
                  onTap: controller.memorySubtract,
                ),
              ],
            ),
          ),

          // Row 7: 1, 2, 3, +, MR
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
                CalcuonButton(
                  label: 'MR',
                  type: CalcButtonType.memory,
                  onTap: controller.memoryRecall,
                ),
              ],
            ),
          ),

          // Row 8: 0 (wide), ., =, MC
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
                CalcuonButton(
                  label: 'MC',
                  type: CalcButtonType.memory,
                  onTap: controller.memoryClear,
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
