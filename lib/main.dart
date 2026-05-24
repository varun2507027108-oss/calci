import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('calculationHistory');
  await Hive.openBox('settings');
  await Hive.openBox('favorites');
  await Hive.openBox('conversionCache');

  runApp(
    const ProviderScope(
      child: CalcuonApp(),
    ),
  );
}
