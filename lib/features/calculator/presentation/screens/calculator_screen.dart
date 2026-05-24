import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_result.dart';
import '../../../../core/widgets/mode_selector.dart';
import '../controllers/calculator_controller.dart';
import '../widgets/display_panel.dart';
import '../widgets/standard_keypad.dart';
import '../widgets/scientific_keypad.dart';
import '../widgets/history_drawer.dart';

/// Main calculator screen.
///
/// Layout:
/// - Top: Display panel (expression + animated result)
/// - Middle: Mode selector (Standard / Scientific)
/// - Bottom: Dynamic keypad (morphs between modes)
/// - Drawer: Swipe-up history panel
class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  int _selectedMode = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calculatorProvider);
    final controller = ref.read(calculatorProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkSurfacePrimary
          : AppColors.lightSurfacePrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ─── DISPLAY PANEL ──────────────────────────────
            Expanded(
              flex: 3,
              child: GestureDetector(
                // Swipe right to backspace
                onHorizontalDragEnd: (details) {
                  if ((details.primaryVelocity ?? 0) > 200) {
                    controller.backspace();
                  }
                },
                child: DisplayPanel(
                  expression: state.expression,
                  result: state.result,
                  error: state.error,
                  hasMemory: state.hasMemory,
                  isDegreeMode: state.isDegreeMode,
                ),
              ),
            ),

            // ─── MODE SELECTOR ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: ModeSelector(
                modes: const ['Standard', 'Scientific'],
                selectedIndex: _selectedMode,
                onModeChanged: (index) {
                  setState(() => _selectedMode = index);
                  controller.toggleScientificMode();
                },
              ),
            ),

            // ─── KEYPAD ────────────────────────────────────
            Expanded(
              flex: _selectedMode == 0 ? 5 : 6,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                child: _selectedMode == 0
                    ? StandardKeypad(
                        key: const ValueKey('standard'),
                        controller: controller,
                        state: state,
                      )
                    : ScientificKeypad(
                        key: const ValueKey('scientific'),
                        controller: controller,
                        state: state,
                      ),
              ),
            ),

            // Bottom padding for nav bar
            SizedBox(height: AppSpacing.bottomNavHeight + bottomPadding),
          ],
        ),
      ),
    );
  }
}
