import 'dart:math' as math;
import 'expression_parser.dart';

/// Statistical calculations engine.
///
/// Supports: mean, median, mode, standard deviation, variance,
/// min, max, range, quartiles, correlation, linear regression,
/// normal distribution.
class StatisticsEngine {
  /// Arithmetic mean.
  double mean(List<double> data) {
    if (data.isEmpty) throw ExpressionError('Empty dataset');
    return data.reduce((a, b) => a + b) / data.length;
  }

  /// Median (middle value).
  double median(List<double> data) {
    if (data.isEmpty) throw ExpressionError('Empty dataset');
    final sorted = List<double>.from(data)..sort();
    final n = sorted.length;
    if (n % 2 == 0) {
      return (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2;
    }
    return sorted[n ~/ 2];
  }

  /// Mode (most frequent value). Returns all modes.
  List<double> mode(List<double> data) {
    if (data.isEmpty) throw ExpressionError('Empty dataset');
    final freq = <double, int>{};
    for (final val in data) {
      freq[val] = (freq[val] ?? 0) + 1;
    }
    final maxFreq = freq.values.reduce(math.max);
    if (maxFreq == 1) return []; // No mode
    return freq.entries.where((e) => e.value == maxFreq).map((e) => e.key).toList();
  }

  /// Population variance.
  double variance(List<double> data, {bool population = true}) {
    if (data.isEmpty) throw ExpressionError('Empty dataset');
    final m = mean(data);
    final sumSq = data.fold<double>(0, (sum, x) => sum + (x - m) * (x - m));
    return sumSq / (population ? data.length : data.length - 1);
  }

  /// Standard deviation.
  double standardDeviation(List<double> data, {bool population = true}) {
    return math.sqrt(variance(data, population: population));
  }

  /// Sample variance (n-1 denominator).
  double sampleVariance(List<double> data) => variance(data, population: false);

  /// Sample standard deviation.
  double sampleStdDev(List<double> data) =>
      standardDeviation(data, population: false);

  /// Minimum value.
  double min(List<double> data) {
    if (data.isEmpty) throw ExpressionError('Empty dataset');
    return data.reduce(math.min);
  }

  /// Maximum value.
  double max(List<double> data) {
    if (data.isEmpty) throw ExpressionError('Empty dataset');
    return data.reduce(math.max);
  }

  /// Range (max - min).
  double range(List<double> data) => max(data) - min(data);

  /// Sum.
  double sum(List<double> data) {
    if (data.isEmpty) return 0;
    return data.reduce((a, b) => a + b);
  }

  /// Count.
  int count(List<double> data) => data.length;

  // ─── QUARTILES ──────────────────────────────────────────────

  /// First quartile (25th percentile).
  double q1(List<double> data) => percentile(data, 25);

  /// Third quartile (75th percentile).
  double q3(List<double> data) => percentile(data, 75);

  /// Interquartile range.
  double iqr(List<double> data) => q3(data) - q1(data);

  /// Percentile (0-100).
  double percentile(List<double> data, double p) {
    if (data.isEmpty) throw ExpressionError('Empty dataset');
    if (p < 0 || p > 100) throw ExpressionError('Percentile must be 0-100');
    final sorted = List<double>.from(data)..sort();
    final index = (p / 100) * (sorted.length - 1);
    final lower = index.floor();
    final upper = index.ceil();
    if (lower == upper) return sorted[lower];
    final frac = index - lower;
    return sorted[lower] * (1 - frac) + sorted[upper] * frac;
  }

  // ─── CORRELATION & REGRESSION ───────────────────────────────

  /// Pearson correlation coefficient.
  double correlation(List<double> x, List<double> y) {
    if (x.length != y.length) {
      throw ExpressionError('X and Y must have same length');
    }
    if (x.length < 2) throw ExpressionError('Need at least 2 data points');

    final mx = mean(x);
    final my = mean(y);
    double sumXY = 0, sumX2 = 0, sumY2 = 0;

    for (int i = 0; i < x.length; i++) {
      final dx = x[i] - mx;
      final dy = y[i] - my;
      sumXY += dx * dy;
      sumX2 += dx * dx;
      sumY2 += dy * dy;
    }

    final denom = math.sqrt(sumX2 * sumY2);
    if (denom == 0) return 0;
    return sumXY / denom;
  }

  /// Linear regression: returns (slope, intercept, r²).
  ({double slope, double intercept, double rSquared}) linearRegression(
    List<double> x,
    List<double> y,
  ) {
    if (x.length != y.length) {
      throw ExpressionError('X and Y must have same length');
    }
    if (x.length < 2) throw ExpressionError('Need at least 2 data points');

    final n = x.length;
    final mx = mean(x);
    final my = mean(y);

    double sumXY = 0, sumX2 = 0;
    for (int i = 0; i < n; i++) {
      sumXY += (x[i] - mx) * (y[i] - my);
      sumX2 += (x[i] - mx) * (x[i] - mx);
    }

    final slope = sumX2 == 0 ? 0.0 : sumXY / sumX2;
    final intercept = my - slope * mx;
    final r = correlation(x, y);
    final rSquared = r * r;

    return (slope: slope, intercept: intercept, rSquared: rSquared);
  }

  // ─── NORMAL DISTRIBUTION ───────────────────────────────────

  /// Probability density function of normal distribution.
  double normalPDF(double x, {double mu = 0, double sigma = 1}) {
    final z = (x - mu) / sigma;
    return math.exp(-0.5 * z * z) / (sigma * math.sqrt(2 * math.pi));
  }

  /// Cumulative distribution function (approximation) of normal distribution.
  double normalCDF(double x, {double mu = 0, double sigma = 1}) {
    final z = (x - mu) / sigma;
    return 0.5 * (1 + _erf(z / math.sqrt2));
  }

  /// Error function approximation (Abramowitz & Stegun).
  double _erf(double x) {
    final sign = x < 0 ? -1.0 : 1.0;
    x = x.abs();

    const a1 = 0.254829592;
    const a2 = -0.284496736;
    const a3 = 1.421413741;
    const a4 = -1.453152027;
    const a5 = 1.061405429;
    const p = 0.3275911;

    final t = 1.0 / (1.0 + p * x);
    final y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x * x);
    return sign * y;
  }

  /// Z-score: how many standard deviations from the mean.
  double zScore(double x, double mean, double stdDev) {
    if (stdDev == 0) throw ExpressionError('Standard deviation cannot be zero');
    return (x - mean) / stdDev;
  }
}
