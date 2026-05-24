import 'dart:math' as math;
import 'expression_parser.dart';

/// Complex number arithmetic.
///
/// Supports: add, subtract, multiply, divide, conjugate,
/// modulus, argument, power, polar form, exponential form.
class ComplexNumber {
  const ComplexNumber(this.real, this.imaginary);

  /// Parse from string: "3+4i", "-2i", "5", etc.
  factory ComplexNumber.parse(String s) {
    s = s.trim().replaceAll(' ', '');
    if (s.isEmpty) return const ComplexNumber(0, 0);

    // Pure imaginary: "4i" or "-3i" or "i"
    if (s.endsWith('i')) {
      final imag = s.substring(0, s.length - 1);
      if (imag.isEmpty || imag == '+') return const ComplexNumber(0, 1);
      if (imag == '-') return const ComplexNumber(0, -1);
      return ComplexNumber(0, double.parse(imag));
    }

    // Check for +/- splitting real and imaginary
    // Find the last + or - that isn't at position 0
    int splitPos = -1;
    for (int i = s.length - 1; i > 0; i--) {
      if ((s[i] == '+' || s[i] == '-') && s[i - 1] != 'e' && s[i - 1] != 'E') {
        splitPos = i;
        break;
      }
    }

    if (splitPos == -1) {
      // Pure real
      return ComplexNumber(double.parse(s), 0);
    }

    final realPart = s.substring(0, splitPos);
    var imagPart = s.substring(splitPos);
    if (imagPart.endsWith('i')) {
      imagPart = imagPart.substring(0, imagPart.length - 1);
      if (imagPart == '+' || imagPart.isEmpty) imagPart = '1';
      if (imagPart == '-') imagPart = '-1';
      return ComplexNumber(double.parse(realPart), double.parse(imagPart));
    }

    throw ExpressionError('Invalid complex number: $s');
  }

  final double real;
  final double imaginary;

  // ─── ARITHMETIC ─────────────────────────────────────────────

  ComplexNumber operator +(ComplexNumber other) {
    return ComplexNumber(real + other.real, imaginary + other.imaginary);
  }

  ComplexNumber operator -(ComplexNumber other) {
    return ComplexNumber(real - other.real, imaginary - other.imaginary);
  }

  ComplexNumber operator *(ComplexNumber other) {
    return ComplexNumber(
      real * other.real - imaginary * other.imaginary,
      real * other.imaginary + imaginary * other.real,
    );
  }

  ComplexNumber operator /(ComplexNumber other) {
    final denominator = other.real * other.real + other.imaginary * other.imaginary;
    if (denominator == 0) throw ExpressionError('Division by zero');
    return ComplexNumber(
      (real * other.real + imaginary * other.imaginary) / denominator,
      (imaginary * other.real - real * other.imaginary) / denominator,
    );
  }

  ComplexNumber operator -() {
    return ComplexNumber(-real, -imaginary);
  }

  // ─── PROPERTIES ─────────────────────────────────────────────

  /// Complex conjugate: a - bi
  ComplexNumber get conjugate => ComplexNumber(real, -imaginary);

  /// Modulus (absolute value): |z| = √(a² + b²)
  double get modulus => math.sqrt(real * real + imaginary * imaginary);

  /// Argument (angle): arg(z) = atan2(b, a) in radians
  double get argument => math.atan2(imaginary, real);

  /// Argument in degrees
  double get argumentDegrees => argument * 180 / math.pi;

  // ─── ADVANCED ───────────────────────────────────────────────

  /// Power: z^n
  ComplexNumber pow(double n) {
    final r = math.pow(modulus, n);
    final theta = argument * n;
    return ComplexNumber(
      r * math.cos(theta),
      r * math.sin(theta),
    );
  }

  /// Square root of complex number
  ComplexNumber sqrt() {
    final r = math.sqrt(modulus);
    final theta = argument / 2;
    return ComplexNumber(r * math.cos(theta), r * math.sin(theta));
  }

  /// Exponential: e^z = e^a * (cos(b) + i*sin(b))
  ComplexNumber exp() {
    final ea = math.exp(real);
    return ComplexNumber(ea * math.cos(imaginary), ea * math.sin(imaginary));
  }

  /// Natural logarithm: ln(z) = ln|z| + i*arg(z)
  ComplexNumber ln() {
    if (modulus == 0) throw ExpressionError('ln(0) is undefined');
    return ComplexNumber(math.log(modulus), argument);
  }

  // ─── DISPLAY ────────────────────────────────────────────────

  /// Format for display: "3+4i", "-2i", "5"
  @override
  String toString() {
    if (imaginary == 0) return _formatDouble(real);
    if (real == 0) {
      if (imaginary == 1) return 'i';
      if (imaginary == -1) return '-i';
      return '${_formatDouble(imaginary)}i';
    }

    final sign = imaginary > 0 ? '+' : '-';
    final absImag = imaginary.abs();
    final imagStr = absImag == 1 ? '' : _formatDouble(absImag);
    return '${_formatDouble(real)}${sign}${imagStr}i';
  }

  /// Polar form string: "r∠θ°"
  String toPolar() {
    return '${_formatDouble(modulus)}∠${_formatDouble(argumentDegrees)}°';
  }

  String _formatDouble(double val) {
    if (val == val.truncateToDouble()) return val.toInt().toString();
    return val.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  @override
  bool operator ==(Object other) {
    if (other is! ComplexNumber) return false;
    return (real - other.real).abs() < 1e-10 &&
        (imaginary - other.imaginary).abs() < 1e-10;
  }

  @override
  int get hashCode => Object.hash(real, imaginary);
}
