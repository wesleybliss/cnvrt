import 'package:cnvrt/config/routing/route_handlers.dart';
import 'package:cnvrt/domain/constants/routing.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static final log = Logger('Routes');

  static const String debug = '/debug';
  static const String debugConvert = '/debug-convert';
  static const String debugSqlTest = '/debug-sql-test';

  static const String home = '/';
  static const String settings = '/settings';
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
        log.w('ROUTE NOT FOUND');
        // return loginHandler.handlerFunc(context, params);
        return errorHandler.handlerFunc(context, params);
      },
    );

    define(debug, debugHandler, TransitionType.fadeIn);
    define(debugConvert, debugConvertHandler, TransitionType.fadeIn);
    define(debugSqlTest, debugSqlTestHandler, TransitionType.fadeIn);

    define(home, homeHandler, TransitionType.fadeIn);
    define(settings, settingsHandler, TransitionType.fadeIn);
    define(currencies, currenciesHandler, TransitionType.fadeIn);
    define(units, unitsHandler, TransitionType.fadeIn);
  }
}
