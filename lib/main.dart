import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/config/application.dart';
import 'app.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // await dotenv.load(fileName: 'assets/.env');

  // Initialize the main application & it's dependencies
  await Application.initialize();

  runApp(ProviderScope(child: SimpleCurrencyApp()));
}
