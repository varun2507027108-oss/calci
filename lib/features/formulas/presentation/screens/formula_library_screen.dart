import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/math/constants.dart';

/// Formula library screen — searchable reference for formulas & constants.
///
/// Tabs: Physics, Chemistry, Math, Constants
/// Each formula displayed as an interactive card with copy-to-clipboard.
class FormulaLibraryScreen extends StatefulWidget {
  const FormulaLibraryScreen({super.key});

  @override
  State<FormulaLibraryScreen> createState() => _FormulaLibraryScreenState();
}

class _FormulaLibraryScreenState extends State<FormulaLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkSurfacePrimary
          : AppColors.lightSurfacePrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm,
              ),
              child: Text(
                'Formulas',
                style: AppTypography.headlineLarge.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceElevated
                      : AppColors.lightSurfaceElevated,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                    width: 0.5,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search formulas...',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Tab bar
            TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorColor: AppColors.accentAmber,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTypography.labelMedium,
              labelColor: AppColors.accentAmber,
              unselectedLabelColor: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              dividerHeight: 0.5,
              dividerColor: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
              tabs: const [
                Tab(text: 'Physics'),
                Tab(text: 'Chemistry'),
                Tab(text: 'Math'),
                Tab(text: 'Constants'),
              ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFormulaList(_physicsFormulas, isDark),
                  _buildFormulaList(_chemistryFormulas, isDark),
                  _buildFormulaList(_mathFormulas, isDark),
                  _buildConstantsList(isDark),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.bottomNavHeight + bottomPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulaList(List<_FormulaEntry> formulas, bool isDark) {
    final filtered = _searchQuery.isEmpty
        ? formulas
        : formulas.where((f) =>
            f.name.toLowerCase().contains(_searchQuery) ||
            f.formula.toLowerCase().contains(_searchQuery) ||
            f.description.toLowerCase().contains(_searchQuery)).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'No formulas found',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final formula = filtered[index];
        return _FormulaCard(formula: formula, isDark: isDark);
      },
    );
  }

  Widget _buildConstantsList(bool isDark) {
    final constants = ScientificConstants.all.entries.where((e) {
      if (_searchQuery.isEmpty) return true;
      return e.value.name.toLowerCase().contains(_searchQuery) ||
          e.value.symbol.toLowerCase().contains(_searchQuery) ||
          e.value.category.toLowerCase().contains(_searchQuery);
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: constants.length,
      itemBuilder: (context, index) {
        final entry = constants[index].value;
        return _ConstantCard(constant: entry, isDark: isDark);
      },
    );
  }
}

// ─── FORMULA CARD ──────────────────────────────────────────────

class _FormulaCard extends StatelessWidget {
  const _FormulaCard({required this.formula, required this.isDark});

  final _FormulaEntry formula;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  formula.name,
                  style: AppTypography.labelLarge.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: formula.formula));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Copied: ${formula.formula}'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            formula.formula,
            style: AppTypography.monoMedium.copyWith(
              color: AppColors.accentAmber,
              fontSize: 16,
            ),
          ),
          if (formula.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              formula.description,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ConstantCard extends StatelessWidget {
  const _ConstantCard({required this.constant, required this.isDark});

  final ConstantEntry constant;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Symbol
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentEmerald.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Center(
              child: Text(
                constant.symbol,
                style: AppTypography.monoMedium.copyWith(
                  color: AppColors.accentEmerald,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  constant.name,
                  style: AppTypography.labelLarge.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${constant.value.toStringAsExponential(6)} ${constant.unit}',
                  style: AppTypography.monoSmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle)
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              constant.category,
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FORMULA DATA ─────────────────────────────────────────────

class _FormulaEntry {
  const _FormulaEntry(this.name, this.formula, this.description);
  final String name;
  final String formula;
  final String description;
}

const _physicsFormulas = [
  _FormulaEntry("Newton's Second Law", 'F = m × a', 'Force equals mass times acceleration'),
  _FormulaEntry('Kinetic Energy', 'KE = ½mv²', 'Energy of a moving object'),
  _FormulaEntry('Potential Energy', 'PE = mgh', 'Energy due to position in gravitational field'),
  _FormulaEntry('Work', 'W = F × d × cos(θ)', 'Force applied over a distance'),
  _FormulaEntry('Power', 'P = W / t', 'Rate of doing work'),
  _FormulaEntry('Momentum', 'p = mv', 'Product of mass and velocity'),
  _FormulaEntry('Impulse', 'J = FΔt = Δp', 'Change in momentum'),
  _FormulaEntry('Gravitational Force', 'F = G(m₁m₂)/r²', 'Newton\'s law of gravitation'),
  _FormulaEntry('Velocity', 'v = u + at', 'Final velocity from initial velocity and acceleration'),
  _FormulaEntry('Displacement', 's = ut + ½at²', 'Distance under constant acceleration'),
  _FormulaEntry("Coulomb's Law", 'F = kq₁q₂/r²', 'Electrostatic force between charges'),
  _FormulaEntry("Ohm's Law", 'V = IR', 'Voltage = Current × Resistance'),
  _FormulaEntry('Wave Speed', 'v = fλ', 'Velocity = frequency × wavelength'),
  _FormulaEntry('Pendulum Period', 'T = 2π√(L/g)', 'Period of a simple pendulum'),
  _FormulaEntry('Photoelectric Effect', 'E = hf - φ', 'Einstein\'s photoelectric equation'),
  _FormulaEntry("Einstein's Mass-Energy", 'E = mc²', 'Mass-energy equivalence'),
  _FormulaEntry("Snell's Law", 'n₁sinθ₁ = n₂sinθ₂', 'Law of refraction'),
  _FormulaEntry('Centripetal Force', 'F = mv²/r', 'Force for circular motion'),
  _FormulaEntry('Ideal Gas Law', 'PV = nRT', 'Relates pressure, volume, and temperature'),
  _FormulaEntry('Doppler Effect', 'f\' = f(v ± v₀)/(v ∓ vₛ)', 'Frequency shift from relative motion'),
];

const _chemistryFormulas = [
  _FormulaEntry('Ideal Gas Law', 'PV = nRT', 'Pressure × Volume = moles × gas constant × Temperature'),
  _FormulaEntry('Molarity', 'M = mol/L', 'Moles of solute per liter of solution'),
  _FormulaEntry('Dilution', 'M₁V₁ = M₂V₂', 'Conservation of moles in dilution'),
  _FormulaEntry('pH', 'pH = -log[H⁺]', 'Measure of acidity'),
  _FormulaEntry('pOH', 'pOH = -log[OH⁻]', 'Measure of basicity'),
  _FormulaEntry('pH + pOH', 'pH + pOH = 14', 'At 25°C in aqueous solution'),
  _FormulaEntry('Boyle\'s Law', 'P₁V₁ = P₂V₂', 'Pressure-volume at constant temperature'),
  _FormulaEntry('Charles\'s Law', 'V₁/T₁ = V₂/T₂', 'Volume-temperature at constant pressure'),
  _FormulaEntry('Rate Law', 'rate = k[A]ⁿ[B]ᵐ', 'Reaction rate as function of concentrations'),
  _FormulaEntry('Gibbs Free Energy', 'ΔG = ΔH - TΔS', 'Spontaneity criterion'),
  _FormulaEntry('Nernst Equation', 'E = E° - (RT/nF)lnQ', 'Cell potential under non-standard conditions'),
  _FormulaEntry('Half-life', 't½ = 0.693/k', 'Time for half of reactant to decay'),
  _FormulaEntry('Henderson-Hasselbalch', 'pH = pKa + log([A⁻]/[HA])', 'Buffer pH calculation'),
  _FormulaEntry('Enthalpy', 'ΔH = ΣΔHf(products) - ΣΔHf(reactants)', 'Heat of reaction'),
];

const _mathFormulas = [
  _FormulaEntry('Quadratic Formula', 'x = (-b ± √(b²-4ac)) / 2a', 'Solutions of ax² + bx + c = 0'),
  _FormulaEntry('Pythagorean Theorem', 'a² + b² = c²', 'Right triangle relationship'),
  _FormulaEntry('Area of Circle', 'A = πr²', 'Area enclosed by a circle'),
  _FormulaEntry('Circumference', 'C = 2πr', 'Perimeter of a circle'),
  _FormulaEntry('Volume of Sphere', 'V = (4/3)πr³', 'Volume enclosed by a sphere'),
  _FormulaEntry('Distance Formula', 'd = √((x₂-x₁)² + (y₂-y₁)²)', 'Distance between two points'),
  _FormulaEntry('Slope', 'm = (y₂-y₁)/(x₂-x₁)', 'Slope of a line through two points'),
  _FormulaEntry('Sin Rule', 'a/sinA = b/sinB = c/sinC', 'Relation between sides and angles'),
  _FormulaEntry('Cos Rule', 'c² = a² + b² - 2ab·cosC', 'Generalized Pythagorean theorem'),
  _FormulaEntry('Euler\'s Identity', 'e^(iπ) + 1 = 0', 'The most beautiful equation'),
  _FormulaEntry('Binomial Theorem', '(a+b)ⁿ = Σ C(n,k) aⁿ⁻ᵏ bᵏ', 'Expansion of binomial powers'),
  _FormulaEntry('Taylor Series', 'f(x) = Σ f⁽ⁿ⁾(a)(x-a)ⁿ/n!', 'Function as infinite polynomial'),
  _FormulaEntry('Integration by Parts', '∫udv = uv - ∫vdu', 'Product rule for integrals'),
  _FormulaEntry('Chain Rule', 'dy/dx = (dy/du)(du/dx)', 'Derivative of composed functions'),
  _FormulaEntry('Log Identity', 'log(ab) = log(a) + log(b)', 'Product rule for logarithms'),
  _FormulaEntry('Arithmetic Series', 'S = n/2(a + l)', 'Sum of arithmetic progression'),
  _FormulaEntry('Geometric Series', 'S = a(1-rⁿ)/(1-r)', 'Sum of geometric progression'),
  _FormulaEntry('Permutations', 'P(n,r) = n!/(n-r)!', 'Ordered arrangements'),
  _FormulaEntry('Combinations', 'C(n,r) = n!/(r!(n-r)!)', 'Unordered selections'),
];
