# cnvrt

A fast, privacy-friendly converter for currencies and common units with full offline support.

[![Flutter CI/CD](https://github.com/wesleybliss/cnvrt/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/wesleybliss/cnvrt/actions/workflows/ci-cd.yml)

[https://wesleybliss.github.io/cnvrt](https://wesleybliss.github.io/cnvrt)

## Table of Contents

- [About](#about)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Development Commands](#development-commands)
- [Build Variants](#build-variants)
- [Localization](#localization)
- [Scripts](#scripts)
- [CI/CD](#cicd)
- [Contributing](#contributing)
- [TODO](#todo)

## About

cnvrt is a Flutter-based conversion application designed for speed, privacy, and offline resilience. It provides near real-time currency exchange rates with local caching for offline use, along with common unit conversions. The app follows clean architecture principles with a domain/io/ui separation pattern and uses Riverpod for state management.

Key highlights:
- 🌍 **Multi-currency support** with real-time exchange rates
- 📱 **Offline-first** architecture with local database caching
- 🎨 **Customizable UI** with light/dark/system themes
- 🌐 **Multi-language** support (English, Spanish, Italian, Korean, Chinese)
- 🔒 **Privacy-focused** with optional FOSS builds (no tracking, no Firebase)
- ⚡ **Fast and responsive** with optimized state management

## Features

### Currency Conversion

- **Real-time Exchange Rates**: Fetches up-to-date rates for a comprehensive list of global currencies
- **Offline Mode**: Latest exchange rates are cached locally, enabling conversions without network connectivity
- **Automatic Refresh**: Configurable update frequency (default: 12 hours)
- **Network Resilience**: Graceful fallback to cached data with retry mechanism
- **Inflation Accounting**: Optional inflation adjustment for historical accuracy
- **Multiple Display Options**: Show exchange rates for all currencies or selected ones only

### Unit Conversion

Supports bidirectional conversion for common units:
- **Temperature**: Celsius ↔ Fahrenheit ↔ Kelvin
- **Distance**: Kilometers ↔ Miles
- **Speed**: Kilometers per hour ↔ Miles per hour
- **Weight**: Kilograms ↔ Pounds
- **Area**: Square Meters ↔ Square Feet
- **Volume**: Liters ↔ Gallons

### User Experience

- **Multi-language Support**: Available in English, Spanish, Italian, Korean, and Chinese
- **Theming**: Light mode, Dark mode, or automatic system theme sync
- **Customization**:
  - Adjustable decimal precision (0-8 places)
  - Large input mode for accessibility
  - Drag-to-reorder currencies
  - Country flags display
  - Copy-to-clipboard buttons
  - Configurable input positioning
- **Data Persistence**: User preferences and settings saved locally
- **Developer Mode**: Debug screens for testing and troubleshooting

## Technology Stack

- **[Flutter](https://flutter.dev)** (Dart SDK ^3.8.1) - Cross-platform UI framework
- **[Riverpod](https://riverpod.dev)** (^2.6.1) - Reactive state management with code generation
  - `riverpod_annotation` for annotation-based provider generation
  - `riverpod_generator` for compile-time provider code generation
- **[Drift](https://drift.simonbinder.eu)** (^2.28.2) - Type-safe SQLite database with reactive queries
  - `drift_flutter` for Flutter-specific adaptations
- **[Fluro](https://pub.dev/packages/fluro)** (^2.0.5) - Declarative routing and navigation
- **[Dio](https://pub.dev/packages/dio)** (^5.7.0) - HTTP client for API requests
- **[spot_di](https://pub.dev/packages/spot_di)** (^1.0.1) - Custom dependency injection with thread safety
- **[Firebase Crashlytics](https://firebase.google.com/products/crashlytics)** (^5.0.3) - Error reporting (Standard build only)
- **[sealed_currencies](https://pub.dev/packages/sealed_currencies)** (^2.4.1) - Comprehensive currency definitions
- **[shared_preferences](https://pub.dev/packages/shared_preferences)** (^2.3.3) - Key-value storage for app settings

### Development Tools

- **[build_runner](https://pub.dev/packages/build_runner)** - Code generation orchestration
- **[flutter_lints](https://pub.dev/packages/flutter_lints)** (^6.0.0) - Official Flutter lint rules
- **[riverpod_lint](https://pub.dev/packages/riverpod_lint)** (^2.6.5) - Riverpod-specific lint rules
- **[custom_lint](https://pub.dev/packages/custom_lint)** (^0.7.6) - Custom lint rule framework

## Architecture

The app follows a **clean architecture pattern** with clear separation of concerns:

```
┌─────────────────────────────────────────────┐
│              UI Layer                       │
│  (Screens, Widgets, Theme)                  │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│         State Management                    │
│  (Riverpod Providers & Notifiers)           │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│          Domain Layer                       │
│  (Business Logic, Models, Constants)        │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│           IO Layer                          │
│  (Settings, Repositories, Data Sources)     │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│      Data Sources                           │
│  (Dio HTTP Client, Drift Database)          │
└─────────────────────────────────────────────┘
```

### Layer Responsibilities

**UI Layer** (`lib/ui/`)
- Screens and widgets organized by feature
- Consumes Riverpod providers for reactive updates
- Theme configuration and styling
- User interaction handling

**State Management** (`lib/domain/di/providers/`)
- Riverpod providers with annotation-based code generation
- State notifiers for complex state logic
- Selector providers for derived state
- Feature-based organization (currencies, settings, units)

**Domain Layer** (`lib/domain/`)
- Business models and entities
- Application constants and configuration
- Extension methods and utilities
- Feature interfaces

**IO Layer** (`lib/io/`, `lib/db/`)
- Repository pattern implementation
- Settings persistence via SharedPreferences
- Database tables and queries via Drift
- API client configuration

**Data Flow**
1. UI triggers an action (e.g., fetch currencies)
2. Provider notifier executes business logic
3. Repository fetches from remote API or local database
4. Data flows back through providers to UI
5. UI rebuilds reactively with new state

### Code Style

The project follows strict conventions documented in [AGENTS.md](AGENTS.md):
- **Naming**: PascalCase for classes/widgets, camelCase for variables/functions, snake_case for files
- **Interfaces**: Prefix with `I` (e.g., `ISettings`)
- **Imports**: Grouped by package/project with clear separation
- **Widgets**: Composition over inheritance with small, focused components
- **Error Handling**: Dedicated error screens/widgets for different scenarios
- **Linting**: Enforced via `analysis_options.yaml` with `flutter_lints` and `riverpod_lint`

## Project Structure

```
cnvrt/
├── lib/
│   ├── domain/              # Business logic and models
│   │   ├── constants/       # App-wide constants (keys, strings, routing)
│   │   ├── di/              # Dependency injection and providers
│   │   │   ├── providers/   # Riverpod providers by feature
│   │   │   └── spot_module.dart
│   │   ├── extensions/      # Dart extension methods
│   │   ├── io/              # Interface definitions
│   │   └── models/          # Data models and entities
│   ├── io/                  # Data persistence layer
│   │   └── settings.dart    # Settings implementation
│   ├── db/                  # Database (Drift)
│   │   ├── repos/           # Repository implementations
│   │   ├── tables/          # Drift table definitions
│   │   └── database.dart    # Database configuration
│   ├── ui/                  # User interface
│   │   ├── screens/         # Feature screens
│   │   │   ├── home/        # Home screen with conversion input
│   │   │   ├── currencies/  # Currency list and management
│   │   │   ├── units/       # Unit conversion screen
│   │   │   ├── settings/    # App settings and preferences
│   │   │   ├── debug/       # Developer/debug screens
│   │   │   └── error/       # Error handling screens
│   │   └── widgets/         # Reusable UI components
│   ├── l10n/                # Localization (ARB files and generated code)
│   ├── utils/               # Utility functions and helpers
│   ├── config/              # App configuration and routing
│   ├── theme.dart           # Theme definitions
│   └── main.dart            # Application entry point
├── bin/                     # Build and utility scripts
├── docs/                    # Documentation
├── android/                 # Android-specific configuration
├── ios/                     # iOS-specific configuration
├── test/                    # Unit and widget tests
└── pubspec.yaml             # Dependencies and project metadata
```

## Getting Started

### Prerequisites

- **Flutter SDK**: ^3.8.1 ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK**: ^3.8.1 (bundled with Flutter)
- **Android Studio** with Android SDK (for Android development)
- **Xcode** (for iOS development, macOS only)
- **ADB** (Android Debug Bridge) for device communication
- A physical device or emulator/simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/wesleybliss/cnvrt.git
   cd cnvrt
   ```

2. **Verify Flutter installation**
   ```bash
   flutter doctor -v
   ```
   Resolve any issues reported by `flutter doctor`.

3. **Install dependencies**
   ```bash
   flutter clean
   flutter pub get
   ```

4. **Generate code** (Riverpod providers, Drift database, etc.)
   ```bash
   # One-time generation
   flutter pub run build_runner build --delete-conflicting-outputs
   
   # Or start watcher for continuous generation during development
   ./bin/watch.sh
   # Or manually:
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

5. **Set up API server** (optional, for live currency data)
   - Start your API server on port 3001 or 3002
   - Bridge ADB ports for device communication:
     ```bash
     adb reverse tcp:3001 tcp:3001
     # Or if using port 3002:
     adb reverse tcp:3002 tcp:3002
     ```

6. **Run the app**
   ```bash
   flutter run
   ```

### First-Time Setup Notes

- No `.env` file or additional configuration is required
- The app will work offline using cached exchange rates
- API server is only needed for fetching live exchange rate updates
- Accept Android licenses if prompted: `flutter doctor --android-licenses`

## Development Commands

### Dependency Management

```bash
# Clean build artifacts and dependencies
flutter clean && flutter pub get

# Update dependencies
flutter pub upgrade
```

### Code Generation

```bash
# Generate code once (Riverpod, Drift, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and regenerate automatically
flutter pub run build_runner watch --delete-conflicting-outputs
# Or use the provided script:
./bin/watch.sh
```

### Testing & Analysis

```bash
# Run static analysis
flutter analyze

# Run all tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Building

```bash
# Build release APK (Standard flavor with Firebase)
flutter build apk --release

# Build debug APK
flutter build apk --debug

# Build for iOS
flutter build ios --release
```

### Deployment

```bash
# Install to wireless device (custom script)
./bin/install-wireless.sh

# Bridge ADB ports for API server
adb reverse tcp:3001 tcp:3001
adb reverse tcp:3002 tcp:3002

# View logs
flutter logs
adb logcat | grep flutter
```

### Localization

```bash
# Generate localization files after editing ARB files
./bin/generate-i10n.sh
# Or manually:
flutter gen-l10n
```

## Build Variants

The app supports two build flavors to accommodate different distribution channels and privacy requirements:

### Standard Build

- **Target**: Google Play Store, Apple App Store
- **Features**: Full-featured with Firebase Crashlytics for error reporting
- **Build command**:
  ```bash
  flutter build apk --flavor standard --release
  ```

### FOSS Build

- **Target**: F-Droid and other FOSS app stores
- **Features**: Excludes all proprietary libraries (Firebase, Google Services)
- **Privacy**: No telemetry, no crash reporting, fully open source
- **Build commands**:
  ```bash
  # Quick build using scripts
  ./bin/build-foss.sh              # Debug
  ./bin/build-foss-release.sh      # Release
  
  # Manual build
  flutter build apk --flavor foss --dart-define=FOSS_BUILD=true --release
  ```

### Key Differences

| Feature | Standard | FOSS |
|---------|----------|------|
| Firebase Crashlytics | ✅ | ❌ |
| Error Reporting | Remote | Local only |
| Google Services | ✅ | ❌ |
| Distribution | Play Store, App Store | F-Droid, GitHub |

**For comprehensive FOSS build documentation, see [docs/FOSS_BUILDS.md](docs/FOSS_BUILDS.md)**

## Localization

The app supports **5 languages**:

- 🇬🇧 **English** (`en`)
- 🇪🇸 **Spanish** (`es`)
- 🇮🇹 **Italian** (`it`)
- 🇰🇷 **Korean** (`ko`)
- 🇨🇳 **Chinese** (`zh`)

### Adding or Updating Translations

1. **Edit or create ARB files** in `lib/l10n/`:
   - `app_en.arb` (English, template)
   - `app_es.arb` (Spanish)
   - `app_it.arb` (Italian)
   - `app_ko.arb` (Korean)
   - `app_zh.arb` (Chinese)

2. **Regenerate localization code**:
   ```bash
   ./bin/generate-i10n.sh
   # Or manually:
   flutter gen-l10n
   ```

3. **Test the translations**:
   - Change device language settings, or
   - Use the in-app language selector in Settings

### Localization Configuration

Localization is configured in `pubspec.yaml`:
```yaml
flutter:
  generate: true
```

And `l10n.yaml` defines the generation settings (if present).

## Scripts

The `bin/` directory contains utility scripts for common development tasks:

| Script | Purpose | Usage |
|--------|---------|-------|
| `build-foss.sh` | Build FOSS debug APK | `./bin/build-foss.sh` |
| `build-foss-release.sh` | Build FOSS release APK | `./bin/build-foss-release.sh` |
| `release.sh` | Package standard release build | `./bin/release.sh` |
| `release-foss.sh` | Package FOSS release build | `./bin/release-foss.sh` |
| `clean.sh` | Clean build artifacts | `./bin/clean.sh` |
| `generate-i10n.sh` | Generate localization files | `./bin/generate-i10n.sh` |
| `install-wireless.sh` | Build and install to wireless device | `./bin/install-wireless.sh` |
| `watch.sh` | Start build_runner watcher | `./bin/watch.sh` |

All scripts should be run from the project root directory.

## CI/CD

The project uses **GitHub Actions** for continuous integration and deployment:

- **Workflow**: [`.github/workflows/ci-cd.yml`](.github/workflows/ci-cd.yml)
- **Triggers**: Push to `master` or `develop` branches
- **Steps**:
  1. Install Flutter and dependencies
  2. Run tests (`flutter test`)
  3. Decode signing keystore
  4. Set up Firebase (Standard build)
  5. Build release APK
  6. Upload build artifacts
  7. Create GitHub release (master branch only)

### Branches

- **`master`**: Stable releases, triggers production builds and GitHub releases
- **`develop`**: Development branch, triggers CI builds without releases

## Contributing

Contributions are welcome! Please follow these guidelines:

1. **Read the code style guide**: [AGENTS.md](AGENTS.md) contains detailed architectural conventions, naming patterns, and best practices

2. **Fork and create a branch**:
   ```bash
   git checkout -b feature/your-feature-name
   # Or for bug fixes:
   git checkout -b fix/issue-description
   ```

3. **Follow the architecture**:
   - Domain/IO/UI separation
   - Use Riverpod for state management
   - Repository pattern for data access
   - Feature-based organization

4. **Write tests** for new features or bug fixes

5. **Run linting and tests** before committing:
   ```bash
   flutter analyze
   flutter test
   ```

6. **Commit with clear messages**:
   - Use conventional commit format: `feat:`, `fix:`, `docs:`, `refactor:`, etc.
   - Example: `feat(currencies): add currency search functionality`

7. **Submit a pull request** with:
   - Clear description of changes
   - Reference to related issues (if applicable)
   - Screenshots/recordings for UI changes

### Development Setup Checklist

- [ ] Flutter SDK installed and `flutter doctor` passes
- [ ] Dependencies installed: `flutter pub get`
- [ ] Code generation running: `./bin/watch.sh`
- [ ] ADB ports bridged if testing with API server
- [ ] Linting passes: `flutter analyze`
- [ ] Tests pass: `flutter test`

## TODO

### Features
- [ ] Common denominations screen (e.g., 50k COP = $usd, 100k, etc.)
- [ ] Basic math operations in conversion inputs
- [ ] Additional unit types:
  - [ ] Data storage (bytes, KB, MB, GB, TB)
  - [ ] Cooking measurements (cups, tablespoons, teaspoons)
  - [ ] Time zones
  - [ ] Pressure units

### UX Improvements
- [ ] More useful tablet layout with multi-pane view
- [ ] Back button on secondary screens should return to home
- [ ] Haptic feedback for interactions
- [ ] Animated transitions between screens
- [ ] Onboarding flow for first-time users

### Technical Improvements
- [ ] Migrate to Material 3 design system
- [ ] Add widget tests for critical user flows
- [ ] Improve error handling and user feedback
- [ ] Performance profiling and optimization
- [ ] Accessibility audit and improvements

---

## License

CNVRT is licensed under **Apache 2.0 with Commons Clause**.

This means:
- ✅ You can use, modify, and distribute the source code
- ✅ You can create derivative works
- ❌ You cannot sell the software or services whose value derives substantially from it

See the [LICENSE](LICENSE) file for full details.

**Questions or Issues?** Open an issue on [GitHub](https://github.com/wesleybliss/cnvrt/issues)
