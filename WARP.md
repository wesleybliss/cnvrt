# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

CNVRT is a Flutter mobile application for currency and unit conversions. The app:
- Fetches real-time exchange rates from an external API (localhost:3002 in dev, Vercel in production)
- Supports offline mode by caching exchange rates locally in a Drift database
- Provides unit conversions (temperature, distance, speed, area, weight, volume)
- Supports multiple languages and light/dark/system theme modes

## Build & Development Commands

### Essential Commands

```bash
# Reset dependencies (when pubspec.yaml changes or build issues occur)
flutter clean && flutter pub get

# Generate code (after changes to @riverpod, Drift tables, or other annotated classes)
flutter pub run build_runner build

# Watch mode for continuous code generation during development
dart run build_runner watch --delete-conflicting-outputs

# Or use the provided script
./watch.sh

# Run static analysis
flutter analyze

# Run all tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Generate localization files (after editing .arb files in lib/l10n)
flutter gen-l10n

# Build release APK
flutter build apk --release

# Build and install to wireless device
./install-wireless.sh
```

### Development Setup

Before running the app, ensure:

1. **External API Server**: The app requires an API server running on port 3002 (development) or deployed to Vercel (production). The server provides currency exchange rates via `/api/currencies` endpoint.

2. **ADB Port Forwarding**: For local development with a physical device or emulator, bridge the ADB ports:
   ```bash
   adb reverse tcp:3002 tcp:3002
   ```

3. **Code Generation**: Run the build_runner initially and after any changes to files with code generation annotations:
   ```bash
   dart run build_runner watch --delete-conflicting-outputs
   ```

## Architecture Overview

### Layer Structure

The codebase follows a **domain/io/ui** architecture with clear separation of concerns:

#### **Domain Layer** (`lib/domain/`)
Contains business logic, interfaces, models, and dependency injection:
- **`di/`**: Custom "Spot" service locator and Riverpod providers
  - `spot.dart` & `spot_module.dart`: Lightweight dependency injection container
  - `providers/`: Riverpod state management (currencies, settings, units)
- **`io/`**: Abstract interfaces (ISettings, IDioClient, ICurrenciesService, ICurrenciesRepo)
- **`models/`**: Data models (CurrencyResponse, etc.)
- **`constants/`**: App-wide constants (strings, keys, routing)

#### **IO Layer** (`lib/io/`)
Concrete implementations of domain interfaces:
- `settings.dart`: Settings implementation using SharedPreferences

#### **UI Layer** (`lib/ui/`)
User interface components:
- **`screens/`**: Full-screen views
  - `currencies/`: Currency conversion screen
  - `units/`: Unit conversion screen  
  - `settings/`: App settings
  - `debug/`: Developer tools (only visible when developer mode enabled)
  - `home/`: Home/dashboard screen
  - `error/`: Error handling screens
- **`widgets/`**: Reusable components
  - `currency_inputs_list/`: Currency input fields
  - `numeric_keyboard_grid/`: Custom numeric keyboard

#### **DB Layer** (`lib/db/`)
Local persistence using Drift:
- **`database.dart`**: Drift database configuration
- **`tables/`**: Table definitions (currencies_table.dart)
- **`repos/`**: Repository implementations for database operations

#### **Config Layer** (`lib/config/`)
Application configuration and routing:
- `application.dart`: App initialization, dependency registration
- `routing/`: Fluro route definitions and handlers

### State Management

**Riverpod** is used throughout for reactive state management:

1. **Settings**: `settingsNotifierProvider` manages user preferences (theme, language, currency settings)
   - Persisted via SharedPreferences
   - Provides selectors for specific settings (`themeProvider`, etc.)

2. **Currencies**: `currenciesProvider` manages currency data
   - Fetches from API and caches in Drift database
   - `selectedCurrenciesProvider` derives list of user-selected currencies
   - `focusedCurrencyInputSymbolProvider` tracks which input is active

3. **Units**: `numericUnitsStateProvider` manages unit conversion state

### Dependency Injection

The app uses a **custom service locator pattern** called "Spot":

- **Registration**: Dependencies are registered in `SpotModule.registerDependencies()` (called during app initialization)
- **Types**: Supports both `factory` (new instance per request) and `singleton` (shared instance)
- **Usage**: Inject via `spot<IInterface>()` function
- **Key Dependencies**:
  - `ISettings` → Settings (singleton)
  - `Dio` → Dio (singleton)
  - `IDioClient` → DioClient (singleton)
  - `ICurrenciesRepo` → CurrenciesRepo (factory)
  - `ICurrenciesService` → CurrenciesService (singleton)

### Data Flow

1. **Currency Updates**:
   - User opens app → `initializeCurrencies()` checks if data is stale
   - If stale or empty → Fetch from API via `CurrenciesService`
   - Response saved to Drift database via `CurrenciesRepo`
   - Provider notifies UI of new state
   - Selected currencies preserved during updates (upsert logic)

2. **Settings Changes**:
   - User modifies setting → `SettingsNotifier` methods update state
   - New settings saved to SharedPreferences
   - Riverpod notifies dependent widgets to rebuild

3. **Offline Support**:
   - API URL determined by build mode (production vs. debug)
   - Network failures caught and logged
   - App uses last cached currencies from Drift database

### Navigation

**Fluro** router with tab-based navigation:
- `MainScreen` manages bottom navigation bar with persistent tab state
- Two main tabs: Currency conversion and Unit conversion
- Each tab has its own Navigator with independent route stack
- Routes defined in `lib/config/routing/routes.dart`
- Route handlers in `lib/config/routing/route_handlers.dart`

## Code Style Guidelines

### Architecture
- Follow domain/io/ui separation strictly
- Use Riverpod for state management (avoid StatefulWidget state when possible)
- Implement repository pattern for data access (interface in domain, implementation in db/)

### Naming Conventions
- **Classes/Widgets**: PascalCase (e.g., `CurrenciesScreen`, `SettingsNotifier`)
- **Variables/Functions**: camelCase (e.g., `fetchCurrencies`, `currenciesRepo`)
- **Files**: snake_case (e.g., `currencies_provider.dart`, `main_screen.dart`)
- **Interfaces**: Prefix with 'I' (e.g., `ISettings`, `ICurrenciesRepo`)

### Imports
- Group imports by functionality
- Package imports first, then project imports
- Use relative imports within the same feature/module

### Widgets
- Use composition with small, focused components
- Extract repeated UI patterns into reusable widgets
- Prefer const constructors where possible for performance

### Error Handling
- Dedicated error screens/widgets for specific scenarios
- Use try-catch in async operations, log errors with custom Logger
- Display user-friendly error messages, log technical details

### Types
- Use strong typing with explicit types
- Mark parameters as `required` when they should not be nullable
- Use nullable types (`?`) only when null is a valid state

### Code Generation
Files ending in `.g.dart` are generated by build_runner. Never edit these manually. Always run:
```bash
dart run build_runner build
```
After modifying files with:
- `@riverpod` annotations (Riverpod code generation)
- Drift table definitions
- `@CopyWith` annotations
- Any other code generation annotations

### Linting
The project uses `flutter_lints` package with additional `riverpod_lint` custom lints:
- Configured in `analysis_options.yaml`
- Run `flutter analyze` to check for issues
- Fix lint warnings before committing

## Localization

The app supports multiple languages using Flutter's built-in localization:

- **ARB files**: Located in `lib/l10n/` (e.g., `app_en.arb`, `app_es.arb`)
- **Config**: `l10n.yaml` defines localization settings
- **Generated files**: `lib/l10n/app_localizations.dart` (auto-generated, don't edit)
- **Usage in code**: 
  ```dart
  AppLocalizations.of(context)!.settings
  ```
- **Add new strings**: 
  1. Edit ARB files in `lib/l10n/`
  2. Run `flutter gen-l10n` to regenerate localization code

## Debugging

### Developer Mode
The app includes hidden debug screens accessible when developer mode is activated:
- Tap version number 10 times in settings to enable
- Routes: `/debug`, `/debug-theme`, `/debug-convert`, `/debug-sql-test`

### Logging
Custom Logger class (imported from `utils/logger.dart`):
- Controlled globally via `Logger.globalLevel` in `Application.initialize()`
- Per-class loggers: `final log = Logger('ClassName')`
- Methods: `log.v()`, `log.d()`, `log.i()`, `log.w()`, `log.e()`

### Common Issues

**Build errors after pulling changes:**
```bash
flutter clean && flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Currency data not loading:**
- Check if API server is running on port 3002
- Verify ADB port forwarding: `adb reverse tcp:3002 tcp:3002`
- Check network logs in debug console

**State not updating:**
- Ensure Riverpod providers are being watched with `ref.watch()`, not `ref.read()` in build methods
- Check if StateNotifier is creating new state instances (immutability)

**Generated files out of sync:**
- Delete `.dart_tool` and run `dart run build_runner build --delete-conflicting-outputs`
