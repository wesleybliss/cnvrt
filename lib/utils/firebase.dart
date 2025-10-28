import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../config/flavor.dart';
import 'logger.dart';

// Conditional imports - only import Firebase for standard builds
import 'package:firebase_core/firebase_core.dart' if (dart.library.js) 'firebase_stub.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart' if (dart.library.js) 'firebase_stub.dart';
import '../firebase_options.dart' if (dart.library.js) 'firebase_stub.dart';

/// Initializes Firebase and Crashlytics with error handling
Future<void> initializeFirebase() async {
  final log = Logger('utils/firebase');
  
  log.d('[Firebase] Starting initialization...');
  log.d('[Firebase] Build flavor: ${FlavorConfig.flavorName}');
  log.d('[Firebase] kDebugMode = $kDebugMode');
  log.d('[Firebase] kReleaseMode = $kReleaseMode');
  log.d('[Firebase] Platform: ${Platform.operatingSystem}');
  
  // Skip Firebase for FOSS builds
  if (!FlavorConfig.isFirebaseEnabled) {
    log.d('[Firebase] FOSS build detected - Firebase features are disabled');
    log.d('[Firebase] Skipping Firebase initialization');
    log.d('[Firebase] App will run without Firebase features (Crashlytics, etc.)');
    return;
  }
  
  // Firebase Core doesn't support Linux natively
  // Skip Firebase initialization on Linux
  if (!kIsWeb && Platform.isLinux) {
    log.d('[Firebase] Linux platform detected - Firebase is not supported natively on Linux');
    log.d('[Firebase] Skipping Firebase initialization');
    log.d('[Firebase] App will run without Firebase features (Crashlytics, etc.)');
    return;
  }
  
  // Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log.d('[Firebase] Firebase Core initialized successfully');

  // Enable Crashlytics collection
  // IMPORTANT: Always enabled for testing, change to !kDebugMode for production
  final crashlyticsEnabled = true; // or !kDebugMode for production
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(crashlyticsEnabled);
  log.d('[Firebase] Crashlytics collection enabled = $crashlyticsEnabled');

  // Check if Crashlytics is actually enabled
  final isCrashlyticsCollectionEnabled = 
      FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;
  log.d('[Firebase] Crashlytics status check = $isCrashlyticsCollectionEnabled');

  // Set custom keys for debugging
  await FirebaseCrashlytics.instance.setCustomKey('flutter_version', '3.x');
  await FirebaseCrashlytics.instance.setCustomKey('build_mode', 
      kDebugMode ? 'debug' : 'release');
  log.d('[Firebase] Custom keys set');

  // Catch all uncaught async errors (errors outside of Flutter framework)
  PlatformDispatcher.instance.onError = (error, stack) {
    log.d('[Firebase] Platform error caught: $error');
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Forward all Flutter framework errors to Crashlytics
  FlutterError.onError = (FlutterErrorDetails details) {
    log.d('[Firebase] Flutter error caught: ${details.exception}');
    // Still show the error in the console during development
    FlutterError.presentError(details);
    // Send to Crashlytics
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };
  
  log.d('[Firebase] Error handlers configured');
  log.d('[Firebase] Initialization complete!');
}
