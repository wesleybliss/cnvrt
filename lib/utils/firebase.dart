import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

/// Initializes Firebase and Crashlytics with error handling
Future<void> initializeFirebase() async {
  // Catch all uncaught async errors (errors outside of Flutter framework)
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Crashlytics collection (disabled in debug mode to avoid noise)
  // In production, this will automatically collect crash reports
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);

  // Forward all Flutter framework errors to Crashlytics
  FlutterError.onError = (FlutterErrorDetails details) {
    // Still show the error in the console during development
    FlutterError.presentError(details);
    // Send to Crashlytics
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };
}
