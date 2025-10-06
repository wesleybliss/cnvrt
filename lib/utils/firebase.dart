import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

/// Initializes Firebase and Crashlytics with error handling
Future<void> initializeFirebase() async {
  print('[Firebase] Starting initialization...');
  print('[Firebase] kDebugMode = $kDebugMode');
  print('[Firebase] kReleaseMode = $kReleaseMode');
  
  // Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('[Firebase] Firebase Core initialized successfully');

  // Enable Crashlytics collection
  // IMPORTANT: Always enabled for testing, change to !kDebugMode for production
  final crashlyticsEnabled = true; // or !kDebugMode for production
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(crashlyticsEnabled);
  print('[Firebase] Crashlytics collection enabled = $crashlyticsEnabled');

  // Check if Crashlytics is actually enabled
  final isCrashlyticsCollectionEnabled = 
      FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;
  print('[Firebase] Crashlytics status check = $isCrashlyticsCollectionEnabled');

  // Set custom keys for debugging
  await FirebaseCrashlytics.instance.setCustomKey('flutter_version', '3.x');
  await FirebaseCrashlytics.instance.setCustomKey('build_mode', 
      kDebugMode ? 'debug' : 'release');
  print('[Firebase] Custom keys set');

  // Catch all uncaught async errors (errors outside of Flutter framework)
  PlatformDispatcher.instance.onError = (error, stack) {
    print('[Firebase] Platform error caught: $error');
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Forward all Flutter framework errors to Crashlytics
  FlutterError.onError = (FlutterErrorDetails details) {
    print('[Firebase] Flutter error caught: ${details.exception}');
    // Still show the error in the console during development
    FlutterError.presentError(details);
    // Send to Crashlytics
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };
  
  print('[Firebase] Error handlers configured');
  print('[Firebase] Initialization complete!');
}
