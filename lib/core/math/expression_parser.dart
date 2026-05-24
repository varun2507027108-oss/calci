import 'dart:math' as math;

/// Shunting-yard expression parser and evaluator.
///
/// Supports:
/// - Basic arithmetic (+, -, *, /)
/// - Parentheses (nested, with implicit multiplication: 2(3) = 6)
/// - Unary minus (-5, -(3+2))
/// - Percentage (5% = 0.05, 100+10% = 110)
/// - Powers (^)
/// - Scientific functions (sin, cos, tan, log, ln, sqrt, etc.)
/// - Constants (π, e)
///
/// Uses Dijkstra's shunting-yard algorithm to convert infix to postfix (RPN),
/// then evaluates the postfix expression.
class ExpressionParser {
  /// Evaluate an infix expression string and return the result.
  ///
  /// Throws [ExpressionError] for malformed expressions.
  double evaluate(String expression, {bool isDegreeMode = true}) {
    final tokens = _tokenize(expression);
    final postfix = _toPostfix(tokens);
    return _evaluatePostfix(postfix, isDegreeMode: isDegreeMode);
  }

  /// Tokenize the expression string into a list of tokens.
  List<_Token> _tokenize(String expr) {
    final tokens = <_Token>[];
    int i = 0;

    // Normalize unicode operators
    expr = expr
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('π', 'pi')
        .replaceAll(',', ''); // Remove thousands separators

    while (i < expr.length) {
      final c = expr[i];

      // Skip whitespace
      if (c == ' ') {
        i++;
        continue;
      }

      // Numbers (including decimals)
      if (_isDigit(c) || (c == '.' && i + 1 < expr.length && _isDigit(expr[i + 1]))) {
        final start = i;
        while (i < expr.length && (_isDigit(expr[i]) || expr[i] == '.')) {
          i++;
        }
        // Scientific notation (e.g., 1.5e10, 2E-3)
        if (i < expr.length && (expr[i] == 'e' || expr[i] == 'E')) {
          i++;
          if (i < expr.length && (expr[i] == '+' || expr[i] == '-')) {
            i++;
          }
          while (i < expr.length && _isDigit(expr[i])) {
            i++;
          }
        }
        tokens.add(_Token.number(double.parse(expr.substring(start, i))));
        continue;
      }

      // Functions and constants
      if (_isAlpha(c)) {
        final start = i;
        while (i < expr.length && _isAlpha(expr[i])) {
          i++;
        }
        final name = expr.substring(start, i).toLowerCase();

        // Constants
        if (name == 'pi') {
          tokens.add(_Token.number(math.pi));
        } else if (name == 'e' && (i >= expr.length || !_isAlpha(expr[i]))) {
          tokens.add(_Token.number(math.e));
        } else {
          // Function name
          tokens.add(_Token.func(name));
        }
        continue;
      }

      // Operators
      if ('+-*/^%'.contains(c)) {
        // Handle unary minus
        if (c == '-' &&
            (tokens.isEmpty ||
                tokens.last.type == _TokenType.operator_ ||
                tokens.last.type == _TokenType.leftParen ||
                tokens.last.type == _TokenType.function_)) {
          tokens.add(_Token.func('neg'));
        } else {
          tokens.add(_Token.operator_(c));
        }
        i++;
        continue;
      }

      // Parentheses
      if (c == '(') {
        // Implicit multiplication: 2(3), )(, pi(
        if (tokens.isNotEmpty &&
            (tokens.last.type == _TokenType.number ||
                tokens.last.type == _TokenType.rightParen)) {
          tokens.add(_Token.operator_('*'));
        }
        tokens.add(_Token.leftParen());
        i++;
        continue;
      }

      if (c == ')') {
        tokens.add(_Token.rightParen());
        i++;
        continue;
      }

      // Unknown character — skip
      i++;
    }

    return tokens;
  }

  /// Convert infix tokens to postfix (RPN) using shunting-yard algorithm.
  List<_Token> _toPostfix(List<_Token> tokens) {
    final output = <_Token>[];
    final stack = <_Token>[];

    for (final token in tokens) {
      switch (token.type) {
        case _TokenType.number:
          output.add(token);

        case _TokenType.function_:
          stack.add(token);

        case _TokenType.operator_:
          while (stack.isNotEmpty &&
              stack.last.type == _TokenType.operator_ &&
              (_precedence(stack.last.value) > _precedence(token.value) ||
                  (_precedence(stack.last.value) == _precedence(token.value) &&
                      _isLeftAssociative(token.value)))) {
            output.add(stack.removeLast());
          }
          stack.add(token);

        case _TokenType.leftParen:
          stack.add(token);

        case _TokenType.rightParen:
          while (stack.isNotEmpty && stack.last.type != _TokenType.leftParen) {
            output.add(stack.removeLast());
          }
          if (stack.isNotEmpty && stack.last.type == _TokenType.leftParen) {
            stack.removeLast();
          }
          // If there's a function on top, pop it to output
          if (stack.isNotEmpty && stack.last.type == _TokenType.function_) {
            output.add(stack.removeLast());
          }
      }
    }

    // Pop remaining operators
    while (stack.isNotEmpty) {
      final token = stack.removeLast();
      if (token.type == _TokenType.leftParen) {
        throw ExpressionError('Mismatched parentheses');
      }
      output.add(token);
    }

    return output;
  }

  /// Evaluate a postfix (RPN) expression.
  double _evaluatePostfix(List<_Token> postfix, {required bool isDegreeMode}) {
    final stack = <double>[];

    for (final token in postfix) {
      switch (token.type) {
        case _TokenType.number:
          stack.add(token.numValue!);

        case _TokenType.operator_:
          if (stack.length < 2) {
            throw ExpressionError('Invalid expression');
          }
          final b = stack.removeLast();
          final a = stack.removeLast();
          stack.add(_applyOperator(token.value, a, b));

        case _TokenType.function_:
          if (stack.isEmpty) {
            throw ExpressionError('Missing argument for ${token.value}');
          }
          final arg = stack.removeLast();
          stack.add(_applyFunction(token.value, arg, isDegreeMode: isDegreeMode));

        default:
          throw ExpressionError('Unexpected token: ${token.value}');
      }
    }

    if (stack.length != 1) {
      throw ExpressionError('Invalid expression');
    }

    return stack.first;
  }

  double _applyOperator(String op, double a, double b) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        if (b == 0) throw ExpressionError('Division by zero');
        return a / b;
      case '^':
        return math.pow(a, b).toDouble();
      case '%':
        // Percentage: a + b% = a + (a * b / 100)
        return a * b / 100;
      default:
        throw ExpressionError('Unknown operator: $op');
    }
  }

  double _applyFunction(String name, double arg, {required bool isDegreeMode}) {
    double toRad(double deg) => deg * math.pi / 180;
    double fromRad(double rad) => rad * 180 / math.pi;

    double inputAngle(double a) => isDegreeMode ? toRad(a) : a;
    double outputAngle(double a) => isDegreeMode ? fromRad(a) : a;

    switch (name) {
      case 'neg':
        return -arg;
      case 'sin':
        return math.sin(inputAngle(arg));
      case 'cos':
        return math.cos(inputAngle(arg));
      case 'tan':
        return math.tan(inputAngle(arg));
      case 'asin':
        return outputAngle(math.asin(arg));
      case 'acos':
        return outputAngle(math.acos(arg));
      case 'atan':
        return outputAngle(math.atan(arg));
      case 'sinh':
        return (math.exp(arg) - math.exp(-arg)) / 2;
      case 'cosh':
        return (math.exp(arg) + math.exp(-arg)) / 2;
      case 'tanh':
        return (math.exp(arg) - math.exp(-arg)) / (math.exp(arg) + math.exp(-arg));
      case 'asinh':
        return math.log(arg + math.sqrt(arg * arg + 1));
      case 'acosh':
        if (arg < 1) throw ExpressionError('acosh undefined for x < 1');
        return math.log(arg + math.sqrt(arg * arg - 1));
      case 'atanh':
        if (arg.abs() >= 1) throw ExpressionError('atanh undefined for |x| >= 1');
        return 0.5 * math.log((1 + arg) / (1 - arg));
      case 'log':
        if (arg <= 0) throw ExpressionError('log undefined for x ≤ 0');
        return math.log(arg) / math.ln10;
      case 'ln':
        if (arg <= 0) throw ExpressionError('ln undefined for x ≤ 0');
        return math.log(arg);
      case 'log2':
        if (arg <= 0) throw ExpressionError('log2 undefined for x ≤ 0');
        return math.log(arg) / math.ln2;
      case 'sqrt':
        if (arg < 0) throw ExpressionError('sqrt undefined for x < 0');
        return math.sqrt(arg);
      case 'cbrt':
        return arg >= 0
            ? math.pow(arg, 1 / 3).toDouble()
            : -math.pow(-arg, 1 / 3).toDouble();
      case 'abs':
        return arg.abs();
      case 'ceil':
        return arg.ceilToDouble();
      case 'floor':
        return arg.floorToDouble();
      case 'round':
        return arg.roundToDouble();
      case 'exp':
        return math.exp(arg);
      case 'fact':
        return _factorial(arg.toInt()).toDouble();
      default:
        throw ExpressionError('Unknown function: $name');
    }
  }

  int _factorial(int n) {
    if (n < 0) throw ExpressionError('Factorial undefined for negative numbers');
    if (n > 170) throw ExpressionError('Factorial overflow');
    if (n <= 1) return 1;
    int result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  int _precedence(String op) {
    switch (op) {
      case '+':
      case '-':
        return 2;
      case '*':
      case '/':
      case '%':
        return 3;
      case '^':
        return 4;
      default:
        return 0;
    }
  }

  bool _isLeftAssociative(String op) => op != '^';

  bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;

  bool _isAlpha(String c) {
    final code = c.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }
}

// ─── TOKEN TYPES ────────────────────────────────────────────────

enum _TokenType {
  number,
  operator_,
  function_,
  leftParen,
  rightParen,
}

class _Token {
  _Token({
    required this.type,
    required this.value,
    this.numValue,
  });

  factory _Token.number(double val) => _Token(
        type: _TokenType.number,
        value: val.toString(),
        numValue: val,
      );

  factory _Token.operator_(String op) => _Token(
        type: _TokenType.operator_,
        value: op,
      );

  factory _Token.func(String name) => _Token(
        type: _TokenType.function_,
        value: name,
      );

  factory _Token.leftParen() => _Token(
        type: _TokenType.leftParen,
        value: '(',
      );

  factory _Token.rightParen() => _Token(
        type: _TokenType.rightParen,
        value: ')',
      );

  final _TokenType type;
  final String value;
  final double? numValue;

  @override
  String toString() => 'Token($type, $value)';
}

// ─── ERRORS ─────────────────────────────────────────────────────

class ExpressionError implements Exception {
  ExpressionError(this.message);
  final String message;

  @override
  String toString() => 'ExpressionError: $message';
}
