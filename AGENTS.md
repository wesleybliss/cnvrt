# CNVRT Project Guidelines

## Core Features

### 1. Currency Conversion

- **Real-time Exchange Rates:** The app fetches up-to-date exchange rates for a wide range of global currencies.
- **Offline Mode:** The latest exchange rates are saved locally, allowing for currency conversions even when the device is offline.
- **Comprehensive Currency List:** Includes a vast selection of world currencies for conversion.

### 2. Unit Conversion

The app provides a convenient tool for various common unit conversions:

- **Temperature:** Celsius, Fahrenheit, and Kelvin.
- **Distance:** Kilometers and Miles.
- **Speed:** Kilometers per hour (kph) and Miles per hour (mph).
- **Area:** Square Meters and Square Feet.
- **Weight:** Kilograms and Pounds.
- **Volume:** Gallons and Liters.

## User Experience

### 1. Multi-language Support

- The app is localized to support multiple languages, providing a native experience for a global audience. Currently supported languages include English and Spanish.

### 2. Theming

- **Light and Dark Modes:** Users can choose between a light or dark theme for comfortable viewing in any lighting condition.
- **System Theme:** The app can also sync with the device's system-wide theme settings.

### 3. Data Persistence

- **User Preferences:** The app remembers user settings, such as the selected theme and language.
- **Local Database:** A local database is used to store app data, including exchange rates for offline use.

## Build & Development Commands
- `flutter clean && flutter pub get` - Reset dependencies
- `flutter pub run build_runner build` - Generate code (after changes to annotated classes)
- `flutter analyze` - Run static analysis
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run single test
- `flutter build apk --release` - Build release APK
- `./install-wireless.sh` - Build and install to wireless device
- `adb reverse tcp:3001 tcp:3001` - Bridge ADB ports for API server

## Code Style Guidelines
- **Architecture**: Follow domain/io/ui separation with Riverpod for state management
- **Naming**: PascalCase for classes/widgets, camelCase for variables/functions, snake_case for files
- **Interfaces**: Prefix with 'I' (e.g., ISettings)
- **Imports**: Group by functionality; package imports first, then project imports
- **Widgets**: Use composition with small, focused components
- **Error Handling**: Dedicated error screens/widgets for specific scenarios
- **Types**: Use strong typing with required parameters
- **Project Structure**: Feature-based organization with domain/io/ui layers
- **Dependencies**: Use Riverpod for state, Drift for storage, Fluro for routing, Dio for networking

Refer to analysis_options.yaml for linting rules (flutter_lints package + riverpod_lint).
