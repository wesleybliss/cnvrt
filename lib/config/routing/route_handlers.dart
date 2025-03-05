import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/ui/screens/currencies/currencies_screen.dart';
import 'package:cnvrt/ui/screens/debug/debug_screen.dart';
import 'package:cnvrt/ui/screens/error/ErrorScreen.dart';
import 'package:cnvrt/ui/screens/home/home_screen.dart';
import 'package:cnvrt/ui/screens/settings/settings_screen.dart';
import 'package:cnvrt/ui/widgets/navbar.dart';
import 'package:cnvrt/ui/widgets/toolbar.dart';

typedef ParamsHandler = Widget Function(Map<String, dynamic> params);

Widget _render(Widget child, String title,
        {withScaffold = true, withBottomBar = true}) =>
    withScaffold
        ? Scaffold(
            appBar: Toolbar(title: title),
            bottomNavigationBar: withBottomBar ? const Navbar() : null,
            body: child,
          )
        : child;

Handler handlerFor(Widget child, String title, {withScaffold = true}) {
  return Handler(handlerFunc: (context, params) {
    return _render(child, title, withScaffold: withScaffold);
  });
}

Handler paramsHandlerFor(ParamsHandler childFn, String title,
    {withScaffold = true}) {
  return Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    final child = childFn(params);
    return _render(child, title, withScaffold: withScaffold);
  });
}

final errorHandler = handlerFor(
    const ErrorScreen(message: '@todo Error'), Constants.strings.appName);
//final splashHandler = handlerFor(SplashScreen(), RouteWrapper.none);

final debugHandler = handlerFor(const DebugScreen(), "Debug");

final homeHandler = handlerFor(const HomeScreen(), Constants.strings.appName);
final settingsHandler = handlerFor(const SettingsScreen(), "Settings");
final currenciesHandler = handlerFor(const CurrenciesScreen(), "Currencies");
