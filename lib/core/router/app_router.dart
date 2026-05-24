import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/calculator/presentation/screens/calculator_screen.dart';
import '../../features/graphing/presentation/screens/graph_screen.dart';
import '../../features/converter/presentation/screens/converter_screen.dart';
import '../../features/formulas/presentation/screens/formula_library_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../widgets/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/calculator',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/calculator',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CalculatorScreen(),
            ),
          ),
          GoRoute(
            path: '/graphing',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GraphScreen(),
            ),
          ),
          GoRoute(
            path: '/converter',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ConverterScreen(),
            ),
          ),
          GoRoute(
            path: '/formulas',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FormulaLibraryScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
