# CNVRT Project Guidelines

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