import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/conversion/conversion_engine.dart';
import '../../../../core/utils/formatters.dart';

/// Unit converter screen — modern conversion dashboard.
///
/// Two modes:
/// 1. Category grid (default) — tap a category to open converter
/// 2. Active converter — dual input with unit pickers and swap animation
class ConverterScreen extends ConsumerStatefulWidget {
  const ConverterScreen({super.key});

  @override
  ConsumerState<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends ConsumerState<ConverterScreen>
    with SingleTickerProviderStateMixin {
  final _engine = ConversionEngine();
  String? _selectedCategory;
  String _fromUnit = '';
  String _toUnit = '';
  final _fromController = TextEditingController(text: '1');
  String _result = '';
  late AnimationController _swapController;
  late Animation<double> _swapRotation;

  @override
  void initState() {
    super.initState();
    _swapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _swapRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _swapController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _swapController.dispose();
    super.dispose();
  }

  void _selectCategory(String category) {
    final units = _engine.getUnits(category);
    setState(() {
      _selectedCategory = category;
      _fromUnit = units.first;
      _toUnit = units.length > 1 ? units[1] : units.first;
      _convert();
    });
  }

  void _convert() {
    final value = double.tryParse(_fromController.text);
    if (value == null) {
      setState(() => _result = '');
      return;
    }
    try {
      final converted = _engine.convert(_selectedCategory!, _fromUnit, _toUnit, value);
      setState(() => _result = NumberFormatter.formatResult(converted));
    } catch (_) {
      setState(() => _result = 'Error');
    }
  }

  void _swapUnits() {
    _swapController.forward(from: 0);
    HapticFeedback.lightImpact();
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
      _convert();
    });
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
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  if (_selectedCategory != null) ...[
                    GestureDetector(
                      onTap: () => setState(() => _selectedCategory = null),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    _selectedCategory ?? 'Convert',
                    style: AppTypography.headlineLarge.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _selectedCategory == null
                  ? _buildCategoryGrid(isDark)
                  : _buildConverter(isDark),
            ),

            SizedBox(height: AppSpacing.bottomNavHeight + bottomPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(bool isDark) {
    final categories = _engine.categories;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final icon = ConversionEngine.categoryIcons[category] ?? '🔢';

        return GestureDetector(
          onTap: () => _selectCategory(category),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceElevated
                  : AppColors.lightSurfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                width: 0.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  category,
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConverter(bool isDark) {
    final units = _engine.getUnits(_selectedCategory!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          // From card
          _UnitCard(
            isDark: isDark,
            label: 'From',
            unit: _fromUnit,
            units: units,
            controller: _fromController,
            isInput: true,
            onUnitChanged: (u) {
              setState(() {
                _fromUnit = u;
                _convert();
              });
            },
            onValueChanged: (_) => _convert(),
          ),

          // Swap button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: GestureDetector(
              onTap: _swapUnits,
              child: RotationTransition(
                turns: _swapRotation,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorderAccent : AppColors.lightBorderAccent,
                      width: 0.5,
                    ),
                  ),
                  child: Icon(
                    Icons.swap_vert_rounded,
                    color: AppColors.accentAmber,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),

          // To card
          _UnitCard(
            isDark: isDark,
            label: 'To',
            unit: _toUnit,
            units: units,
            resultText: _result,
            isInput: false,
            onUnitChanged: (u) {
              setState(() {
                _toUnit = u;
                _convert();
              });
            },
          ),
        ],
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({
    required this.isDark,
    required this.label,
    required this.unit,
    required this.units,
    required this.onUnitChanged,
    this.controller,
    this.resultText,
    this.isInput = false,
    this.onValueChanged,
  });

  final bool isDark;
  final String label;
  final String unit;
  final List<String> units;
  final ValueChanged<String> onUnitChanged;
  final TextEditingController? controller;
  final String? resultText;
  final bool isInput;
  final ValueChanged<String>? onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              // Value
              Expanded(
                child: isInput
                    ? TextField(
                        controller: controller,
                        onChanged: onValueChanged,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        style: AppTypography.displaySmall.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      )
                    : Text(
                        resultText ?? '',
                        style: AppTypography.displaySmall.copyWith(
                          color: AppColors.accentAmber,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),

              // Unit picker
              GestureDetector(
                onTap: () => _showUnitPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfacePrimary
                        : AppColors.lightSurfaceKeypad,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        unit,
                        style: AppTypography.labelLarge.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUnitPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      builder: (ctx) {
        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: units.length,
          itemBuilder: (_, i) {
            final u = units[i];
            final isSelected = u == unit;
            return ListTile(
              title: Text(
                u,
                style: AppTypography.bodyLarge.copyWith(
                  color: isSelected
                      ? AppColors.accentAmber
                      : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_rounded, color: AppColors.accentAmber, size: 20)
                  : null,
              onTap: () {
                onUnitChanged(u);
                Navigator.pop(ctx);
              },
            );
          },
        );
      },
    );
  }
}
