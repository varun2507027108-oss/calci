# Calcuon — Premium Scientific Calculator

A next-generation cross-platform scientific calculator built with Flutter.
Matte titanium dark aesthetic with amber gold accents.

## Features

- **Standard Calculator** — Basic arithmetic, memory, history, swipe gestures
- **Scientific Calculator** — Full trig, log, factorial, complex numbers, matrix ops
- **Graph Plotter** — 2D graphing with pinch-to-zoom, multiple equations, derivatives
- **Unit Converter** — 13 categories, 150+ units, real-time conversion
- **Formula Library** — Physics, Chemistry, Math formulas + scientific constants
- **Settings** — Dark/Light/System theme, haptics, preferences

## Getting Started

### Prerequisites

- Flutter SDK 3.7+ (https://flutter.dev/docs/get-started/install)
- Dart 3.7+
- Android Studio / Xcode for platform tooling

### Setup

```bash
# Install Flutter (if not installed)
# See: https://docs.flutter.dev/get-started/install

# Navigate to project
cd calci

# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run on specific platform
flutter run -d chrome     # Web
flutter run -d ios        # iOS Simulator
flutter run -d android    # Android Emulator
```

### Download Fonts

The app uses custom fonts. Download and place them in `assets/fonts/`:

1. **Space Grotesk** — https://fonts.google.com/specimen/Space+Grotesk
2. **DM Sans** — https://fonts.google.com/specimen/DM+Sans
3. **JetBrains Mono** — https://fonts.google.com/specimen/JetBrains+Mono

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Architecture

```
Clean Architecture + Riverpod + GoRouter
├── core/          (theme, math engine, graph engine, conversion engine)
├── features/      (calculator, graphing, converter, formulas, settings)
└── assets/        (fonts, data, icons)
```

## Tech Stack

- **Framework**: Flutter 3.7+
- **State**: Riverpod
- **Navigation**: GoRouter
- **Storage**: Hive
- **Math**: Custom shunting-yard parser
- **Graphs**: CustomPainter
- **Fonts**: Space Grotesk, DM Sans, JetBrains Mono

## Design

Matte Titanium Dark aesthetic:
- Near-black surfaces (#0D0D0F)
- Warm amber gold accents (#D4A853)
- Deep emerald secondary (#2D8B6F)
- Frosted glass surfaces with backdrop blur
- 80ms tactile button animations with haptic feedback
