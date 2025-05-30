import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:cnvrt/ui/screens/currencies/currencies_screen.dart';
import 'package:cnvrt/ui/screens/debug/debug_convert_screen.dart';
import 'package:cnvrt/ui/screens/debug/debug_screen.dart';
import 'package:cnvrt/ui/screens/debug/debug_sql_test_screen.dart';
import 'package:cnvrt/ui/screens/debug/debug_theme_screen.dart';
import 'package:cnvrt/ui/screens/error/ErrorScreen.dart';
import 'package:cnvrt/ui/screens/home/home_screen.dart';
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
  bool withBottomBar = true,
}) =>
    withScaffold
        ? Scaffold(
          appBar: Toolbar(title: title, allowBackNavigation: allowBackNavigation),
          // bottomNavigationBar: withBottomBar ? const BottomNavbar() : null, // removed in favor of MainScreen
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

final errorHandler = handlerFor(const ErrorScreen(message: '@todo Error'), (context) => Constants.strings.appName);
//final splashHandler = handlerFor(SplashScreen(), RouteWrapper.none);

final debugHandler = handlerFor(const DebugScreen(), (context) => "Debug");
final debugThemeHandler = handlerFor(const DebugThemeScreen(), (context) => "Debug Theme");
final debugConvertHandler = handlerFor(const DebugConvertScreen(), (context) => "Debug Convert");
final debugSqlTestHandler = handlerFor(const DebugSqlTestScreen(), (context) => "Debug Sql Test");

final homeHandler = handlerFor(const HomeScreen(), (context) => Constants.strings.appName);
final settingsHandler = handlerFor(const SettingsScreen(), (context) => AppLocalizations.of(context)!.settings);
final currenciesHandler = handlerFor(const CurrenciesScreen(), (context) => AppLocalizations.of(context)!.currencies, allowBackNavigation: false);
final unitsHandler = handlerFor(UnitsScreen(), (context) => AppLocalizations.of(context)!.units, allowBackNavigation: false);
