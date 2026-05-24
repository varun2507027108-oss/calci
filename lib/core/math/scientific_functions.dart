import 'dart:math' as math;
import 'expression_parser.dart';

/// Extended scientific functions library.
///
/// Covers: trig, hyperbolic, logarithmic, powers/roots,
/// factorial, permutations, combinations, base conversions.
class ScientificFunctions {
  final ExpressionParser _parser = ExpressionParser();

  // ─── PERMUTATIONS & COMBINATIONS ────────────────────────────

  /// P(n, r) = n! / (n-r)!
  double permutation(int n, int r) {
    if (r > n || n < 0 || r < 0) {
      throw ExpressionError('Invalid permutation arguments');
    }
    double result = 1;
    for (int i = n; i > n - r; i--) {
      result *= i;
    }
    return result;
  }

  /// C(n, r) = n! / (r!(n-r)!)
  double combination(int n, int r) {
    if (r > n || n < 0 || r < 0) {
      throw ExpressionError('Invalid combination arguments');
    }
    if (r > n - r) r = n - r; // Optimize
    double result = 1;
    for (int i = 0; i < r; i++) {
      result *= (n - i);
      result /= (i + 1);
    }
    return result;
  }

  // ─── GAMMA FUNCTION (for non-integer factorials) ────────────

  /// Lanczos approximation of Gamma function.
  double gamma(double z) {
    if (z < 0.5) {
      return math.pi / (math.sin(math.pi * z) * gamma(1 - z));
    }

    z -= 1;
    const g = 7;
    const c = [
      0.99999999999980993,
      676.5203681218851,
      -1259.1392167224028,
      771.32342877765313,
      -176.61502916214059,
      12.507343278686905,
      -0.13857109526572012,
      9.9843695780195716e-6,
      1.5056327351493116e-7,
    ];

    double x = c[0];
    for (int i = 1; i < g + 2; i++) {
      x += c[i] / (z + i);
    }

    final t = z + g + 0.5;
    return math.sqrt(2 * math.pi) * math.pow(t, z + 0.5) * math.exp(-t) * x;
  }

  /// Factorial using Gamma: n! = Gamma(n+1)
  double factorial(double n) {
    if (n < 0) throw ExpressionError('Factorial undefined for negative numbers');
    if (n > 170) throw ExpressionError('Factorial overflow');
    if (n == n.truncateToDouble() && n >= 0) {
      // Integer factorial
      double result = 1;
      for (int i = 2; i <= n.toInt(); i++) {
        result *= i;
      }
      return result;
    }
    return gamma(n + 1);
  }

  // ─── BASE CONVERSIONS ──────────────────────────────────────

  /// Convert a decimal integer to binary string.
  String toBinary(int n) {
    if (n == 0) return '0';
    final isNeg = n < 0;
    n = n.abs();
    final buffer = StringBuffer();
    while (n > 0) {
      buffer.write(n % 2);
      n ~/= 2;
    }
    final result = buffer.toString().split('').reversed.join();
    return isNeg ? '-$result' : result;
  }

  /// Convert a decimal integer to octal string.
  String toOctal(int n) {
    if (n == 0) return '0';
    final isNeg = n < 0;
    n = n.abs();
    final buffer = StringBuffer();
    while (n > 0) {
      buffer.write(n % 8);
      n ~/= 8;
    }
    final result = buffer.toString().split('').reversed.join();
    return isNeg ? '-$result' : result;
  }

  /// Convert a decimal integer to hexadecimal string.
  String toHexadecimal(int n) {
    if (n == 0) return '0';
    final isNeg = n < 0;
    n = n.abs();
    const digits = '0123456789ABCDEF';
    final buffer = StringBuffer();
    while (n > 0) {
      buffer.write(digits[n % 16]);
      n ~/= 16;
    }
    final result = buffer.toString().split('').reversed.join();
    return isNeg ? '-$result' : result;
  }

  /// Parse binary string to decimal.
  int fromBinary(String bin) {
    return int.parse(bin, radix: 2);
  }

  /// Parse octal string to decimal.
  int fromOctal(String oct) {
    return int.parse(oct, radix: 8);
  }

  /// Parse hexadecimal string to decimal.
  int fromHex(String hex) {
    return int.parse(hex, radix: 16);
  }

  // ─── GCD & LCM ─────────────────────────────────────────────

  int gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  int lcm(int a, int b) {
    return (a * b).abs() ~/ gcd(a, b);
  }

  // ─── NUMERICAL METHODS ─────────────────────────────────────

  /// Numerical derivative at point x using central difference.
  double derivative(double Function(double) f, double x, {double h = 1e-8}) {
    return (f(x + h) - f(x - h)) / (2 * h);
  }

  /// Numerical integral using Simpson's rule.
  double integrate(
    double Function(double) f,
    double a,
    double b, {
    int n = 1000,
  }) {
    if (n % 2 != 0) n++;
    final h = (b - a) / n;
    double sum = f(a) + f(b);

    for (int i = 1; i < n; i++) {
      final x = a + i * h;
      sum += (i % 2 == 0 ? 2 : 4) * f(x);
    }

    return sum * h / 3;
  }

  /// Find root using Newton-Raphson method.
  double findRoot(
    double Function(double) f,
    double guess, {
    double tolerance = 1e-10,
    int maxIterations = 100,
  }) {
    double x = guess;
    for (int i = 0; i < maxIterations; i++) {
      final fx = f(x);
      if (fx.abs() < tolerance) return x;
      final dfx = derivative(f, x);
      if (dfx.abs() < 1e-15) throw ExpressionError('Derivative too small');
      x -= fx / dfx;
    }
    throw ExpressionError('Root not found within $maxIterations iterations');
  }
}
