import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:cnvrt/ui/screens/currencies/currencies_screen.dart';
import 'package:cnvrt/ui/screens/debug/debug_convert_screen.dart';
import 'package:cnvrt/ui/screens/debug/debug_screen.dart';
import 'package:cnvrt/ui/screens/debug/debug_sql_test_screen.dart';
import 'package:cnvrt/ui/screens/debug/debug_theme_screen.dart';
import 'package:cnvrt/ui/screens/error/error_screen.dart';
import 'package:cnvrt/ui/screens/home/home_screen.dart';
import 'package:cnvrt/ui/screens/settings/inflation_help_screen.dart';
import 'package:cnvrt/ui/screens/settings/settings_screen.dart';
import 'package:cnvrt/ui/screens/units/units_screen.dart';
import 'package:cnvrt/ui/widgets/toolbar.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

typedef ParamsHandler = Widget Function(Map<String, dynamic> params);

Widget _render(
  Widget child,
  String title, {
  bool allowBackNavigation = true,
  bool withScaffold = true,
}) =>
    withScaffold
        ? Scaffold(
          appBar: Toolbar(title: title, allowBackNavigation: allowBackNavigation),
          body: child,
        )
        : child;

Handler handlerFor(
  Widget child,
  String Function(BuildContext) titleBuilder, {
  withScaffold = true,
  bool allowBackNavigation = true,
}) {
  return Handler(
    handlerFunc: (context, params) {
      if (context == null) {
        throw Exception("Context is required for localization.");
      }
      final title = titleBuilder(context);
      return _render(child, title, withScaffold: withScaffold, allowBackNavigation: allowBackNavigation);
    },
  );
}

Handler paramsHandlerFor(ParamsHandler childFn, String Function(BuildContext) titleBuilder, {withScaffold = true}) {
  return Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      if (context == null) {
        throw Exception("Context is required for localization.");
      }
      final title = titleBuilder(context);
      final child = childFn(params);
      return _render(child, title, withScaffold: withScaffold);
    },
  );
}

final errorHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    if (context == null) {
      throw Exception("Context is required for localization.");
    }
    
    // Extract error message from URL params (comes as List<String> from Fluro)
    final messageParam = params['message'];
    final message = messageParam is List ? messageParam.first : messageParam?.toString();
    
    // Create exception from message if provided
    final errorArg = message != null ? Exception(message) : null;
    final title = Constants.strings.appName;
    
    return _render(
      ErrorScreen(error: errorArg, stackTrace: null),
      title,
    );
  },
);
//final splashHandler = handlerFor(SplashScreen(), RouteWrapper.none);

final debugHandler = handlerFor(const DebugScreen(), (context) => "Debug");
final debugThemeHandler = handlerFor(const DebugThemeScreen(), (context) => "Debug Theme");
final debugConvertHandler = handlerFor(const DebugConvertScreen(), (context) => "Debug Convert");
final debugSqlTestHandler = handlerFor(const DebugSqlTestScreen(), (context) => "Debug Sql Test");

final homeHandler = Handler(
  handlerFunc: (context, params) {
    if (context == null) {
      throw Exception("Context is required for localization.");
    }
    // No Scaffold wrapper - MainScreen provides the shared AppBar
    return const HomeScreen();
  },
);
final settingsHandler = handlerFor(const SettingsScreen(), (context) => AppLocalizations.of(context)!.settings);
final inflationHelpHandler = handlerFor(const InflationHelpScreen(), (context) => AppLocalizations.of(context)!.inflationHelpTitle);
final currenciesHandler = handlerFor(const CurrenciesScreen(), (context) => AppLocalizations.of(context)!.currencies, allowBackNavigation: false);
// No Scaffold wrapper for units - MainScreen provides the shared AppBar
final unitsHandler = Handler(
  handlerFunc: (context, params) {
    if (context == null) {
      throw Exception("Context is required for localization.");
    }
    return UnitsScreen();
  },
);
