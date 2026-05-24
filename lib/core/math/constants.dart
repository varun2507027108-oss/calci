import 'dart:math' as math;

/// Scientific constants library.
///
/// CODATA 2018 recommended values where applicable.
/// Organized by physics domain for the formula library.
abstract final class ScientificConstants {
  // ─── MATHEMATICAL ───────────────────────────────────────────

  static const double pi = math.pi;
  static const double e = math.e;
  static const double goldenRatio = 1.6180339887498948;
  static const double sqrt2 = math.sqrt2;
  static const double ln2 = math.ln2;
  static const double ln10 = math.ln10;

  // ─── PHYSICS ────────────────────────────────────────────────

  static const double speedOfLight = 299792458; // m/s
  static const double gravitationalConstant = 6.67430e-11; // m³/(kg·s²)
  static const double planckConstant = 6.62607015e-34; // J·s
  static const double reducedPlanck = 1.054571817e-34; // J·s
  static const double boltzmannConstant = 1.380649e-23; // J/K
  static const double avogadroNumber = 6.02214076e23; // 1/mol
  static const double gasConstant = 8.314462618; // J/(mol·K)
  static const double elementaryCharge = 1.602176634e-19; // C
  static const double electronMass = 9.1093837015e-31; // kg
  static const double protonMass = 1.67262192369e-27; // kg
  static const double neutronMass = 1.67492749804e-27; // kg
  static const double fineStructure = 7.2973525693e-3; // dimensionless
  static const double magneticPermeability = 1.25663706212e-6; // N/A²
  static const double electricPermittivity = 8.8541878128e-12; // F/m
  static const double stefanBoltzmann = 5.670374419e-8; // W/(m²·K⁴)
  static const double wienDisplacement = 2.897771955e-3; // m·K
  static const double rydbergConstant = 10973731.568160; // 1/m
  static const double bohrRadius = 5.29177210903e-11; // m
  static const double standardGravity = 9.80665; // m/s²
  static const double standardAtmosphere = 101325; // Pa

  // ─── CHEMISTRY ──────────────────────────────────────────────

  static const double faradayConstant = 96485.33212; // C/mol
  static const double molarVolumeSTP = 0.022414; // m³/mol
  static const double atomicMassUnit = 1.66053906660e-27; // kg

  /// All constants as a searchable map for the formula library.
  static const Map<String, ConstantEntry> all = {
    'π': ConstantEntry('π', 'Pi', pi, '', 'Mathematical'),
    'e': ConstantEntry('e', "Euler's number", e, '', 'Mathematical'),
    'φ': ConstantEntry('φ', 'Golden ratio', goldenRatio, '', 'Mathematical'),
    'c': ConstantEntry('c', 'Speed of light', speedOfLight, 'm/s', 'Physics'),
    'G': ConstantEntry('G', 'Gravitational constant', gravitationalConstant, 'm³/(kg·s²)', 'Physics'),
    'h': ConstantEntry('h', 'Planck constant', planckConstant, 'J·s', 'Physics'),
    'ℏ': ConstantEntry('ℏ', 'Reduced Planck', reducedPlanck, 'J·s', 'Physics'),
    'kB': ConstantEntry('kB', 'Boltzmann constant', boltzmannConstant, 'J/K', 'Physics'),
    'NA': ConstantEntry('NA', 'Avogadro number', avogadroNumber, '1/mol', 'Physics'),
    'R': ConstantEntry('R', 'Gas constant', gasConstant, 'J/(mol·K)', 'Chemistry'),
    'qe': ConstantEntry('qe', 'Elementary charge', elementaryCharge, 'C', 'Physics'),
    'me': ConstantEntry('me', 'Electron mass', electronMass, 'kg', 'Physics'),
    'mp': ConstantEntry('mp', 'Proton mass', protonMass, 'kg', 'Physics'),
    'mn': ConstantEntry('mn', 'Neutron mass', neutronMass, 'kg', 'Physics'),
    'α': ConstantEntry('α', 'Fine-structure constant', fineStructure, '', 'Physics'),
    'μ₀': ConstantEntry('μ₀', 'Magnetic permeability', magneticPermeability, 'N/A²', 'Physics'),
    'ε₀': ConstantEntry('ε₀', 'Electric permittivity', electricPermittivity, 'F/m', 'Physics'),
    'σ': ConstantEntry('σ', 'Stefan-Boltzmann', stefanBoltzmann, 'W/(m²·K⁴)', 'Physics'),
    'g': ConstantEntry('g', 'Standard gravity', standardGravity, 'm/s²', 'Physics'),
    'atm': ConstantEntry('atm', 'Standard atmosphere', standardAtmosphere, 'Pa', 'Physics'),
    'F': ConstantEntry('F', 'Faraday constant', faradayConstant, 'C/mol', 'Chemistry'),
    'u': ConstantEntry('u', 'Atomic mass unit', atomicMassUnit, 'kg', 'Chemistry'),
  };
}

/// A single scientific constant entry.
class ConstantEntry {
  const ConstantEntry(this.symbol, this.name, this.value, this.unit, this.category);

  final String symbol;
  final String name;
  final double value;
  final String unit;
  final String category;
}
