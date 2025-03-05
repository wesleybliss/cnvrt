import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  // wtf,
  disabled,
}

abstract class ColorCodes {
  static const reset = '\x1B[0m';
  static const black = '\x1B[30m';
  static const white = '\x1B[37m';
  static const red = '\x1B[31m';
  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const blue = '\x1B[34m';
  static const cyan = '\x1B[36m';
}

final severityMap = {
  LogLevel.verbose: 'verbose',
  LogLevel.debug: 'debug',
  LogLevel.info: 'info',
  LogLevel.warning: 'warning',
  LogLevel.error: 'error',
};

final severityColorMap = {
  LogLevel.verbose: ColorCodes.blue,
  LogLevel.debug: ColorCodes.green,
  LogLevel.info: ColorCodes.cyan,
  LogLevel.warning: ColorCodes.yellow,
  LogLevel.error: ColorCodes.red,
};

class Logger {
  /// Context tag (e.g. the class/function/etc name the logger is being used within)
  final String tag;

  /// Log level (default: [LogLevel.debug])
  LogLevel? level;

  /// Global prefix after [level] but before [tag]
  String? prefix;

  /// Whether to colorize output (only works in some consoles)
  bool? colorize;

  /// Use the native [print] function instead of Dart's [developer.log] method
  bool? usePrint;

  static LogLevel globalLevel = LogLevel.debug;
  static String globalPrefix = '';
  static bool globalColorize = false;
  static bool globalUsePrint = false;

  Logger(this.tag, [this.level, this.prefix, this.colorize, this.usePrint]);

  bool get shouldColorize => colorize == true || globalColorize;

  String _createName(LogLevel severity) {
    var prefix = '${severityMap[severity]}';

    if (shouldColorize) {
      prefix = severityColorMap[severity]! + prefix + ColorCodes.reset;
    }

    return prefix;
  }

  String _stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;

    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = const JsonEncoder.withIndent(null);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }

  void _print(LogLevel severity, dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      final useLevel = level ?? globalLevel;
      // print('---- debug ---- severity: ${severity.index}, level = ${useLevel.index}');
      if (severity.index >= useLevel.index) {
        final name = _createName(severity);
        final prefixText = prefix?.isNotEmpty == true ? '[$prefix]' : globalPrefix.isNotEmpty ? '[$globalPrefix]' : '';
        final messageWithTag = '$prefixText [$tag] ${_stringifyMessage(message)}';

        if (usePrint == true || globalUsePrint) {
          print('[$name] $messageWithTag');
        } else {
          developer.log(
            messageWithTag,
            name: name,
            time: null,
            sequenceNumber: null,
            zone: null,
            error: error,
            stackTrace: stackTrace,
          );
        }
      }
    }
  }

  void e(dynamic message, [Object? error, StackTrace? stackTrace]) {
    _print(LogLevel.error, '$message $error $stackTrace');
  }

  void w(dynamic message, [Object? error, StackTrace? stackTrace]) {
    _print(LogLevel.warning, '$message $error $stackTrace');
  }

  void i(dynamic message) {
    _print(LogLevel.info, message);
  }

  void d(dynamic message) {
    _print(LogLevel.debug, message);
  }

  void v(dynamic message) {
    _print(LogLevel.verbose, message);
  }
}
