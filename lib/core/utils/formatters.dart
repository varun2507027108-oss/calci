/// Number formatting utilities for the calculator display.
///
/// Handles display formatting: commas, scientific notation,
/// trailing zero removal, and precision control.
class NumberFormatter {
  /// Format a result number for display.
  ///
  /// Rules:
  /// 1. Integers display without decimal point (e.g., "42")
  /// 2. Decimals show up to [precision] digits, trailing zeros removed
  /// 3. Very large (>1e15) or very small (<1e-10) use scientific notation
  /// 4. Thousands separators for readability
  static String formatResult(double value, {int precision = 10}) {
    if (value.isNaN) return 'Error';
    if (value.isInfinite) return value.isNegative ? '-∞' : '∞';

    // Check for integer result
    if (value == value.truncateToDouble() && value.abs() < 1e15) {
      return _addThousandsSeparator(value.toInt().toString());
    }

    // Scientific notation for extreme values
    if (value.abs() >= 1e15 || (value != 0 && value.abs() < 1e-10)) {
      return _formatScientific(value, precision: 6);
    }

    // Standard decimal formatting
    String formatted = value.toStringAsFixed(precision);

    // Remove trailing zeros
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }

    // Add thousands separators to integer part
    final parts = formatted.split('.');
    parts[0] = _addThousandsSeparator(parts[0]);

    return parts.join('.');
  }

  /// Format as scientific notation (e.g., "1.23×10⁶")
  static String _formatScientific(double value, {int precision = 6}) {
    if (value == 0) return '0';

    final exp = (value.abs().log() / 2.302585092994046).floor();
    final mantissa = value / _pow10(exp);

    String mantissaStr = mantissa.toStringAsFixed(precision);
    // Remove trailing zeros
    mantissaStr = mantissaStr.replaceAll(RegExp(r'0+$'), '');
    mantissaStr = mantissaStr.replaceAll(RegExp(r'\.$'), '');

    return '$mantissaStr×10${_superscript(exp)}';
  }

  /// Format for the expression line (no thousands separators)
  static String formatExpression(String expr) {
    return expr
        .replaceAll('*', '×')
        .replaceAll('/', '÷')
        .replaceAll('-', '−');
  }

  static String _addThousandsSeparator(String number) {
    final isNegative = number.startsWith('-');
    if (isNegative) number = number.substring(1);

    final buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      if (i > 0 && (number.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(number[i]);
    }

    return isNegative ? '-${buffer.toString()}' : buffer.toString();
  }

  static double _pow10(int exp) {
    double result = 1;
    for (int i = 0; i < exp.abs(); i++) {
      result *= 10;
    }
    return exp >= 0 ? result : 1 / result;
  }

  static String _superscript(int n) {
    const superscripts = {
      '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴',
      '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹',
      '-': '⁻',
    };
    return n.toString().split('').map((c) => superscripts[c] ?? c).join();
  }
}
