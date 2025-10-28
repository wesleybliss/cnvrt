// ignore_for_file: constant_identifier_names

/// Build flavor configuration
/// 
/// This file determines which flavor the app is built with.
/// The flavor affects which features are enabled (e.g., Firebase).
/// 
/// To build different flavors:
/// - Standard (with Firebase): flutter build apk --flavor standard
/// - FOSS (without Firebase): flutter build apk --flavor foss --dart-define=FOSS_BUILD=true
library;

enum Flavor {
  STANDARD,
  FOSS,
}

class FlavorConfig {
  /// Determines if this is a FOSS build
  /// Set via --dart-define=FOSS_BUILD=true during build
  static const bool isFossBuild = bool.fromEnvironment('FOSS_BUILD', defaultValue: false);
  
  /// Current flavor based on build configuration
  static Flavor get currentFlavor => isFossBuild ? Flavor.FOSS : Flavor.STANDARD;
  
  /// Whether Firebase features should be enabled
  static bool get isFirebaseEnabled => !isFossBuild;
  
  /// Human-readable flavor name
  static String get flavorName => isFossBuild ? 'FOSS' : 'Standard';
}
