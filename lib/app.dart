import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_selectors.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimpleCurrencyApp extends ConsumerWidget {
  SimpleCurrencyApp({super.key}) {
    if (Application.isInitialized) return;

    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  Widget buildApp(BuildContext context, ThemeMode themeMode) {
    return MaterialApp(
      title: Constants.strings.appName,
      theme: ThemeData(
        useMaterial3: true,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        colorSchemeSeed: const Color.fromRGBO(178, 239, 155, 171),
      ),
      // darkTheme: ThemeData.dark(),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromRGBO(178, 239, 155, 171),
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      initialRoute: Routes.home,
      onGenerateRoute: Application.router.generator,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsyncValue = ref.watch(themeProvider);

    return themeAsyncValue.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (theme) {
        final themeMode =
            theme == "system"
                ? ThemeMode.system
                : theme == "dark"
                ? ThemeMode.dark
                : ThemeMode.light;
        return buildApp(context, themeMode);
      },
    );
  }
}
