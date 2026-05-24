import 'dart:math' as math;
import 'expression_parser.dart';

/// Matrix operations engine — supports up to 10×10 matrices.
///
/// Operations: add, subtract, multiply, transpose, determinant,
/// inverse, row echelon form, identity, scalar multiply.
class MatrixEngine {
  /// Create a matrix from a 2D list.
  Matrix createMatrix(List<List<double>> data) {
    return Matrix(data);
  }

  /// Create an identity matrix of size n.
  Matrix identity(int n) {
    final data = List.generate(
      n,
      (i) => List.generate(n, (j) => i == j ? 1.0 : 0.0),
    );
    return Matrix(data);
  }

  /// Create a zero matrix of size rows × cols.
  Matrix zeros(int rows, int cols) {
    final data = List.generate(
      rows,
      (_) => List.generate(cols, (_) => 0.0),
    );
    return Matrix(data);
  }
}

/// A mathematical matrix with core operations.
class Matrix {
  Matrix(this.data) {
    rows = data.length;
    cols = data.isEmpty ? 0 : data[0].length;

    // Validate dimensions
    for (final row in data) {
      if (row.length != cols) {
        throw ExpressionError('Matrix rows must have equal length');
      }
    }
  }

  final List<List<double>> data;
  late final int rows;
  late final int cols;

  double get(int r, int c) => data[r][c];
  void set(int r, int c, double val) => data[r][c] = val;

  /// Matrix addition.
  Matrix operator +(Matrix other) {
    _checkSameDimensions(other);
    return Matrix(List.generate(
      rows,
      (i) => List.generate(cols, (j) => data[i][j] + other.data[i][j]),
    ));
  }

  /// Matrix subtraction.
  Matrix operator -(Matrix other) {
    _checkSameDimensions(other);
    return Matrix(List.generate(
      rows,
      (i) => List.generate(cols, (j) => data[i][j] - other.data[i][j]),
    ));
  }

  /// Matrix multiplication.
  Matrix operator *(Matrix other) {
    if (cols != other.rows) {
      throw ExpressionError(
        'Matrix multiplication: ${rows}×$cols cannot multiply ${other.rows}×${other.cols}',
      );
    }
    return Matrix(List.generate(
      rows,
      (i) => List.generate(other.cols, (j) {
        double sum = 0;
        for (int k = 0; k < cols; k++) {
          sum += data[i][k] * other.data[k][j];
        }
        return sum;
      }),
    ));
  }

  /// Scalar multiplication.
  Matrix scale(double scalar) {
    return Matrix(List.generate(
      rows,
      (i) => List.generate(cols, (j) => data[i][j] * scalar),
    ));
  }

  /// Transpose.
  Matrix transpose() {
    return Matrix(List.generate(
      cols,
      (j) => List.generate(rows, (i) => data[i][j]),
    ));
  }

  /// Determinant (recursive cofactor expansion).
  double determinant() {
    if (rows != cols) throw ExpressionError('Determinant requires square matrix');
    return _det(data, rows);
  }

  double _det(List<List<double>> mat, int n) {
    if (n == 1) return mat[0][0];
    if (n == 2) return mat[0][0] * mat[1][1] - mat[0][1] * mat[1][0];

    double det = 0;
    for (int j = 0; j < n; j++) {
      final minor = _getMinor(mat, 0, j, n);
      det += (j % 2 == 0 ? 1 : -1) * mat[0][j] * _det(minor, n - 1);
    }
    return det;
  }

  List<List<double>> _getMinor(List<List<double>> mat, int row, int col, int n) {
    final minor = <List<double>>[];
    for (int i = 0; i < n; i++) {
      if (i == row) continue;
      final newRow = <double>[];
      for (int j = 0; j < n; j++) {
        if (j == col) continue;
        newRow.add(mat[i][j]);
      }
      minor.add(newRow);
    }
    return minor;
  }

  /// Inverse using adjugate method.
  Matrix inverse() {
    if (rows != cols) throw ExpressionError('Inverse requires square matrix');
    final det = determinant();
    if (det.abs() < 1e-15) throw ExpressionError('Matrix is singular (det ≈ 0)');

    final n = rows;
    final cofactors = List.generate(n, (i) => List.generate(n, (j) {
      final minor = _getMinor(data, i, j, n);
      return ((i + j) % 2 == 0 ? 1 : -1) * _det(minor, n - 1);
    }));

    // Adjugate = transpose of cofactor matrix
    final adj = Matrix(cofactors).transpose();
    return adj.scale(1 / det);
  }

  /// Row echelon form (Gaussian elimination).
  Matrix rowEchelon() {
    final result = List.generate(rows, (i) => List<double>.from(data[i]));
    int lead = 0;

    for (int r = 0; r < rows; r++) {
      if (lead >= cols) break;

      // Find pivot
      int i = r;
      while (result[i][lead].abs() < 1e-15) {
        i++;
        if (i == rows) {
          i = r;
          lead++;
          if (lead == cols) return Matrix(result);
        }
      }

      // Swap rows
      final temp = result[i];
      result[i] = result[r];
      result[r] = temp;

      // Scale pivot row
      final pivot = result[r][lead];
      for (int j = 0; j < cols; j++) {
        result[r][j] /= pivot;
      }

      // Eliminate column
      for (int k = 0; k < rows; k++) {
        if (k == r) continue;
        final factor = result[k][lead];
        for (int j = 0; j < cols; j++) {
          result[k][j] -= factor * result[r][j];
        }
      }

      lead++;
    }

    return Matrix(result);
  }

  /// Trace (sum of diagonal elements).
  double trace() {
    if (rows != cols) throw ExpressionError('Trace requires square matrix');
    double sum = 0;
    for (int i = 0; i < rows; i++) {
      sum += data[i][i];
    }
    return sum;
  }

  void _checkSameDimensions(Matrix other) {
    if (rows != other.rows || cols != other.cols) {
      throw ExpressionError(
        'Matrix dimensions mismatch: ${rows}×$cols vs ${other.rows}×${other.cols}',
      );
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    for (final row in data) {
      buffer.writeln(row.map((v) => v.toStringAsFixed(4).padLeft(10)).join(' '));
    }
    return buffer.toString();
  }
}
