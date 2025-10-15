import 'package:cnvrt/domain/io/i_settings.dart';
import 'package:cnvrt/io/settings.dart';
import 'package:spot_di/spot_di.dart';

/// Comprehensive test helper for Spot DI container.
/// 
/// Provides utilities for:
/// - State isolation (saveState/restoreState)
/// - Mock registration
/// - Test isolation (runIsolated)
/// - Debugging (getRegistrationInfo)
/// - Dependency setup and teardown
class SpotTestHelper {
  /// Saved registry state for restoration
  static final _savedRegistry = <SpotKey, SpotService>{};
  static Settings defaultTestSettings = Settings(
  roundingDecimals: 2,
  accountForInflation: false,
  theme: "system",
  language: "en",
  updateFrequencyInHours: 12,
  useLargeInputs: false,
  showDragReorderHandles: true,
  showCopyToClipboardButtons: true,
  showFullCurrencyNameLabel: true,
  inputsPosition: "center",
  showCurrencyRate: "selected",
  showCountryFlags: true,
  allowDecimalInput: false,
  developerModeActive: false,
  );
  
  /// Save the current registry state.
  /// 
  /// Useful for preserving the global DI state before running isolated tests.
  /// Call [restoreState] to restore the saved state.
  /// 
  /// Example:
  /// ```dart
  /// SpotTestHelper.saveState();
  /// // Make test-specific registrations
  /// // Run tests
  /// SpotTestHelper.restoreState();
  /// ```
  static void saveState() {
    _savedRegistry.clear();
    _savedRegistry.addAll(Spot.registry);
  }

  /// Restore the previously saved registry state.
  /// 
  /// Clears the current registry and restores it to the state
  /// captured by [saveState]. The saved state is then cleared.
  static void restoreState() {
    Spot.registry.clear();
    Spot.registry.addAll(_savedRegistry);
    _savedRegistry.clear();
  }

  /// Reset the DI container by disposing all services.
  /// 
  /// This will:
  /// - Call dispose() on all registered services
  /// - Clear the registry
  /// - Trigger Disposable cleanup for services that implement it
  static void resetDI() {
    Spot.disposeAll();
  }

  /// Registers a Settings instance as ISettings in the Spot container.
  static void registerSettings(Settings settings) {
    Spot.registerSingle<ISettings, Settings>((get) => settings);
  }

  /// Sets up test dependencies with default or custom settings.
  /// 
  /// This method:
  /// - Resets the DI container
  /// - Registers a Settings instance (default or provided)
  static void setupTestDependencies({Settings? settings}) {
    resetDI();
    
    // Use provided settings or create a default test settings instance
    final testSettings = settings ?? defaultTestSettings;
    
    registerSettings(testSettings);
  }

  static void updateTestDependencies(Function(Settings settings) updateFn) {
    resetDI();

    // Use provided settings or create a default test settings instance
    final testSettings = updateFn(defaultTestSettings);

    registerSettings(testSettings);
  }

  /// Register a mock instance for testing.
  /// 
  /// Convenience method for registering mocks without specifying the concrete type.
  /// The mock is registered as both interface and concrete implementation.
  /// 
  /// Parameters:
  /// - [mock]: The mock instance to register
  /// - [name]: Optional name qualifier for named instances
  /// 
  /// Example:
  /// ```dart
  /// final mockSettings = MockSettings();
  /// SpotTestHelper.registerMock<ISettings>(mockSettings);
  /// 
  /// // Named mock
  /// SpotTestHelper.registerMock<HttpClient>(mockClient, name: 'public');
  /// ```
  static void registerMock<T>(T mock, {String? name}) {
    Spot.registerSingle<T, T>((get) => mock, name: name);
  }

  /// Check if a type is registered in the DI container.
  /// 
  /// Wrapper around [Spot.isRegistered] for convenience.
  /// 
  /// Parameters:
  /// - [name]: Optional name qualifier for named instances
  static bool isRegistered<T>({String? name}) {
    return Spot.isRegistered<T>(name: name);
  }

  /// Get detailed registration information for a type.
  /// 
  /// Returns a formatted string with:
  /// - Registration status
  /// - Target type (concrete implementation)
  /// - Service type (singleton/factory/async singleton)
  /// - Initialization status
  /// 
  /// Useful for debugging test setup issues.
  /// 
  /// Parameters:
  /// - [name]: Optional name qualifier for named instances
  /// 
  /// Example:
  /// ```dart
  /// print(SpotTestHelper.getRegistrationInfo<ISettings>());
  /// // Output: ISettings -> Settings [singleton] (initialized)
  /// 
  /// print(SpotTestHelper.getRegistrationInfo<HttpClient>(name: 'public'));
  /// // Output: HttpClient(public) -> PublicHttpClient [singleton] (initialized)
  /// ```
  static String getRegistrationInfo<T>({String? name}) {
    final key = SpotKey<T>(T, name);
    
    if (!Spot.registry.containsKey(key)) {
      return '$key: NOT REGISTERED';
    }

    final service = Spot.registry[key]!;
    final typeStr = switch (service.type) {
      SpotType.singleton => 'singleton',
      SpotType.factory => 'factory',
      SpotType.asyncSingleton => 'async singleton',
    };
    final hasInstance = service.instance != null;
    return '$key -> ${service.targetType} [$typeStr] ${hasInstance ? "(initialized)" : "(not initialized)"}';
  }

  /// Run a test function with isolated DI state.
  /// 
  /// Automatically saves the current registry state before running the test
  /// and restores it afterwards, even if the test throws an exception.
  /// 
  /// This ensures that tests don't affect each other's DI state.
  /// 
  /// Example:
  /// ```dart
  /// test('currency conversion works', () async {
  ///   await SpotTestHelper.runIsolated(() async {
  ///     // Register test-specific mocks
  ///     SpotTestHelper.registerMock<ISettings>(MockSettings());
  ///     
  ///     // Run test
  ///     final result = performConversion();
  ///     expect(result, equals(expected));
  ///   });
  ///   // Original DI state automatically restored
  /// });
  /// ```
  static Future<void> runIsolated(Future<void> Function() testFn) async {
    saveState();
    try {
      await testFn();
    } finally {
      restoreState();
    }
  }
}
