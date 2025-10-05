import 'package:cnvrt/domain/di/spot.dart';
import 'package:cnvrt/domain/io/i_settings.dart';
import 'package:cnvrt/io/settings.dart';

/// Test helper for setting up and tearing down Spot DI container in tests.
class SpotTestHelper {
  /// Clears all registered dependencies from the Spot container.
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
    final testSettings = settings ?? Settings(
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
    
    registerSettings(testSettings);
  }
}
