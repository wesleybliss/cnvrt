import 'package:cnvrt/domain/di/spot.dart';
import 'package:cnvrt/domain/io/i_settings.dart';
import 'package:cnvrt/io/settings.dart';

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
  static final _savedRegistry = <Type, SpotService>{};
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
  /// Example:
  /// ```dart
  /// final mockSettings = MockSettings();
  /// SpotTestHelper.registerMock<ISettings>(mockSettings);
  /// ```
  static void registerMock<T>(T mock) {
    Spot.registerSingle<T, T>((get) => mock);
  }

  /// Check if a type is registered in the DI container.
  /// 
  /// Wrapper around [Spot.isRegistered] for convenience.
  static bool isRegistered<T>() {
    return Spot.isRegistered<T>();
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
  /// Example:
  /// ```dart
  /// print(SpotTestHelper.getRegistrationInfo<ISettings>());
  /// // Output: ISettings -> Settings [singleton] (initialized)
  /// ```
  static String getRegistrationInfo<T>() {
    if (!Spot.registry.containsKey(T)) {
      return '$T: NOT REGISTERED';
    }

    final service = Spot.registry[T]!;
    final typeStr = switch (service.type) {
      SpotType.singleton => 'singleton',
      SpotType.factory => 'factory',
      SpotType.asyncSingleton => 'async singleton',
    };
    final hasInstance = service.instance != null;
    return '$T -> ${service.targetType} [$typeStr] ${hasInstance ? "(initialized)" : "(not initialized)"}';
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
