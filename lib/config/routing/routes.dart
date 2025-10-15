import 'package:cnvrt/config/routing/route_handlers.dart';
import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/domain/constants/routing.dart';
import 'package:cnvrt/ui/screens/error/error_screen.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static final log = Logger('Routes');

  static const String debug = '/debug';
  static const String debugTheme = '/debug-theme';
  static const String debugConvert = '/debug-convert';
  static const String debugSqlTest = '/debug-sql-test';

  static const String home = '/';
  static const String error = '/error';
  static const String settings = '/settings';
  static const String inflationHelp = '/settings/inflation-help';
  static const String currencies = '/currencies';
  static const String units = '/units';

  static Function defineDefault(FluroRouter router) => (
    String routePath,
    Handler handler, [
    TransitionType transitionType = defaultTransition,
  ]) {
    log.i('Define route: $routePath');

    router.define(routePath, handler: handler, transitionType: transitionType);
  };

  static void configureRoutes(FluroRouter router) {
    Function define = defineDefault(router);

    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        log.w('ROUTE NOT FOUND: ${context?.settings?.name}');
        final error = Exception('Route not found: ${context?.settings?.name}');
        return Scaffold(
          appBar: AppBar(title: Text(Constants.strings.appName)),
          body: ErrorScreen(error: error, stackTrace: null),
        );
      },
    );

    define(debug, debugHandler, TransitionType.fadeIn);
    define(debugTheme, debugThemeHandler, TransitionType.fadeIn);
    define(debugConvert, debugConvertHandler, TransitionType.fadeIn);
    define(debugSqlTest, debugSqlTestHandler, TransitionType.fadeIn);

    define(home, homeHandler, TransitionType.fadeIn);
    define(error, errorHandler, TransitionType.fadeIn);
    define(settings, settingsHandler, TransitionType.fadeIn);
    define(inflationHelp, inflationHelpHandler, TransitionType.fadeIn);
    define(currencies, currenciesHandler, TransitionType.fadeIn);
    define(units, unitsHandler, TransitionType.fadeIn);
  }
}
