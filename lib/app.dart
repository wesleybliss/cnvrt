import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_selectors.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:cnvrt/ui/main_screen.dart';
import 'package:cnvrt/ui/screens/error/error_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const overrideLocale = true;

class SimpleCurrencyApp extends ConsumerWidget {
  static bool _errorWidgetBuilderSet = false;
  
  SimpleCurrencyApp({super.key}) {
    if (Application.isInitialized) return;

    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;

    // Configure global error widget builder to use our ErrorScreen
    // Skip this in test environment as the test framework requires ErrorWidget.builder to remain unchanged
    // We detect test environment by checking the binding type string
    final bindingType = WidgetsBinding.instance.runtimeType.toString();
    final isTestEnvironment = bindingType.contains('Test');
    
    if (!_errorWidgetBuilderSet && !isTestEnvironment) {
      _errorWidgetBuilderSet = true;
      ErrorWidget.builder = (FlutterErrorDetails details) {
        final exception = details.exception is Exception
            ? details.exception as Exception
            : Exception(details.exception.toString());
        return ErrorScreen(
          error: exception,
          stackTrace: details.stack,
        );
      };
    }
  }

  Widget buildApp(BuildContext context, ThemeMode themeMode, String languageCode) {
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
      locale: languageCode == "system" ? null : Locale(languageCode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsyncValue = ref.watch(themeProvider);
    final settingsAsyncValue = ref.watch(settingsNotifierProvider);

    if (themeAsyncValue is AsyncLoading || settingsAsyncValue is AsyncLoading) {
      return const CircularProgressIndicator();
    }

    if (themeAsyncValue is AsyncError) {
      return Text('Error: ${themeAsyncValue.error}');
    }

    if (settingsAsyncValue is AsyncError) {
      return Text('Error: ${settingsAsyncValue.error}');
    }

    final theme = themeAsyncValue.value!;
    final settings = settingsAsyncValue.value!;

    final themeMode =
        theme == "system"
            ? ThemeMode.system
            : theme == "dark"
            ? ThemeMode.dark
            : ThemeMode.light;

    return buildApp(context, themeMode, settings.language);
  }
}
