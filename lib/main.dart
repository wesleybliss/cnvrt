import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/utils/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() async {
  // Preserve the splash screen while the app initializes
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase, crash logging, etc.
  await initializeFirebase();
  
  // Initialize the main application & it's dependencies
  await Application.initialize();

  // Run the app
  runApp(ProviderScope(child: SimpleCurrencyApp()));

  // Remove the splash screen after initialization (e.g., after themeProvider is ready)
  // This can be moved to a later point in your app's lifecycle if needed
  FlutterNativeSplash.remove();
}
