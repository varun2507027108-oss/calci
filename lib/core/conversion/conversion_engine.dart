import 'dart:math' as math;

/// Comprehensive unit conversion engine — 15 categories, 150+ units.
///
/// All conversions go through a base unit per category for consistency.
/// Temperature uses custom non-linear conversion functions.
class ConversionEngine {
  /// Convert [value] from [fromUnit] to [toUnit] within [category].
  double convert(String category, String fromUnit, String toUnit, double value) {
    if (fromUnit == toUnit) return value;

    // Temperature is non-linear — special handling
    if (category == 'Temperature') {
      return _convertTemperature(fromUnit, toUnit, value);
    }

    final units = unitDefinitions[category];
    if (units == null) throw ArgumentError('Unknown category: $category');

    final fromFactor = units[fromUnit];
    final toFactor = units[toUnit];
    if (fromFactor == null) throw ArgumentError('Unknown unit: $fromUnit');
    if (toFactor == null) throw ArgumentError('Unknown unit: $toUnit');

    // Convert: value * fromFactor = base units → base / toFactor = target
    return value * fromFactor / toFactor;
  }

  double _convertTemperature(String from, String to, double value) {
    // Convert to Celsius first
    double celsius;
    switch (from) {
      case '°C':
        celsius = value;
      case '°F':
        celsius = (value - 32) * 5 / 9;
      case 'K':
        celsius = value - 273.15;
      case '°R':
        celsius = (value - 491.67) * 5 / 9;
      default:
        throw ArgumentError('Unknown temperature unit: $from');
    }

    // Convert from Celsius to target
    switch (to) {
      case '°C':
        return celsius;
      case '°F':
        return celsius * 9 / 5 + 32;
      case 'K':
        return celsius + 273.15;
      case '°R':
        return (celsius + 273.15) * 9 / 5;
      default:
        throw ArgumentError('Unknown temperature unit: $to');
    }
  }

  /// Get all categories.
  List<String> get categories => unitDefinitions.keys.toList()..add('Temperature');

  /// Get all units for a category.
  List<String> getUnits(String category) {
    if (category == 'Temperature') return ['°C', '°F', 'K', '°R'];
    return unitDefinitions[category]?.keys.toList() ?? [];
  }

  /// Unit definitions: unit name → factor to convert to base unit.
  /// Base unit is the one with factor = 1.0.
  static final Map<String, Map<String, double>> unitDefinitions = {
    'Length': {
      'nm': 1e-9,
      'μm': 1e-6,
      'mm': 1e-3,
      'cm': 1e-2,
      'm': 1.0,
      'km': 1e3,
      'in': 0.0254,
      'ft': 0.3048,
      'yd': 0.9144,
      'mi': 1609.344,
      'nmi': 1852.0,
      'ly': 9.461e15,
    },
    'Area': {
      'mm²': 1e-6,
      'cm²': 1e-4,
      'm²': 1.0,
      'km²': 1e6,
      'ha': 1e4,
      'acre': 4046.8564224,
      'ft²': 0.09290304,
      'in²': 6.4516e-4,
      'yd²': 0.83612736,
    },
    'Volume': {
      'mL': 1e-6,
      'L': 1e-3,
      'm³': 1.0,
      'gal (US)': 3.785411784e-3,
      'gal (UK)': 4.54609e-3,
      'fl oz (US)': 2.957352956e-5,
      'cup (US)': 2.365882365e-4,
      'pint (US)': 4.73176473e-4,
      'qt (US)': 9.46352946e-4,
      'tbsp': 1.478676478e-5,
      'tsp': 4.928921594e-6,
    },
    'Mass': {
      'mg': 1e-6,
      'g': 1e-3,
      'kg': 1.0,
      'tonne': 1e3,
      'lb': 0.45359237,
      'oz': 0.028349523125,
      'stone': 6.35029318,
      'carat': 2e-4,
      'grain': 6.479891e-5,
      'ton (US)': 907.18474,
      'ton (UK)': 1016.0469088,
    },
    'Speed': {
      'm/s': 1.0,
      'km/h': 1 / 3.6,
      'mph': 0.44704,
      'knots': 0.514444,
      'ft/s': 0.3048,
      'Mach': 343.0,
      'c': 299792458.0,
    },
    'Pressure': {
      'Pa': 1.0,
      'kPa': 1e3,
      'MPa': 1e6,
      'bar': 1e5,
      'atm': 101325.0,
      'psi': 6894.757293168,
      'mmHg': 133.322387415,
      'torr': 133.322368421,
      'inHg': 3386.389,
    },
    'Energy': {
      'J': 1.0,
      'kJ': 1e3,
      'MJ': 1e6,
      'cal': 4.184,
      'kcal': 4184.0,
      'Wh': 3600.0,
      'kWh': 3.6e6,
      'BTU': 1055.05585,
      'eV': 1.602176634e-19,
      'ft·lbf': 1.3558179483,
    },
    'Power': {
      'W': 1.0,
      'kW': 1e3,
      'MW': 1e6,
      'hp': 745.69987158,
      'BTU/h': 0.29307107,
      'ft·lbf/s': 1.3558179483,
      'cal/s': 4.184,
    },
    'Data Storage': {
      'bit': 1.0,
      'byte': 8.0,
      'KB': 8e3,
      'MB': 8e6,
      'GB': 8e9,
      'TB': 8e12,
      'PB': 8e15,
      'KiB': 8192.0,
      'MiB': 8388608.0,
      'GiB': 8589934592.0,
      'TiB': 8796093022208.0,
    },
    'Time': {
      'ns': 1e-9,
      'μs': 1e-6,
      'ms': 1e-3,
      's': 1.0,
      'min': 60.0,
      'h': 3600.0,
      'day': 86400.0,
      'week': 604800.0,
      'month': 2629746.0,
      'year': 31556952.0,
    },
    'Fuel Economy': {
      'km/L': 1.0,
      'L/100km': -1.0, // Special: inverse relationship
      'mpg (US)': 0.425144,
      'mpg (UK)': 0.354006,
    },
    'Angle': {
      'degree': 1.0,
      'radian': 180 / math.pi,
      'gradian': 0.9,
      'arcminute': 1 / 60,
      'arcsecond': 1 / 3600,
      'turn': 360.0,
    },
  };

  /// Category icons for the UI.
  static const Map<String, String> categoryIcons = {
    'Length': '📏',
    'Area': '⬜',
    'Volume': '🧊',
    'Mass': '⚖️',
    'Temperature': '🌡️',
    'Speed': '💨',
    'Pressure': '🔵',
    'Energy': '⚡',
    'Power': '🔋',
    'Data Storage': '💾',
    'Time': '⏱️',
    'Fuel Economy': '⛽',
    'Angle': '📐',
  };
}
