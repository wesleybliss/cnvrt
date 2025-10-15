import 'dart:convert';
import 'dart:math';

import 'package:avatars/avatars.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:cnvrt/utils/logger.dart';

void todo(String message) {
  throw Exception('@todo $message');
}

String jsonPretty(Object? object, [String indent = '    ']) {
  final encoder = JsonEncoder.withIndent(indent);
  return encoder.convert(object);
}

abstract class Utils {
  static final log = Logger('Utils');

  static const _base64SafeEncoder = Base64Codec.urlSafe();

  /// Checks if the system has dark mode enabled.
  /// This version does not require a context.
  /// For context usage, use Context.isSystemDarkMode()
  static bool get isSystemDarkMode {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  /*static void changeAppTitle(String title) {
    SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
      label: 'Dynamic web app title',
      primaryColor: Theme.of(Keys.navigatorKey.currentContext!).primaryColor.value,
    ));
  }*/

  static void noop() {}

  static Future sleep(int seconds) => Future.delayed(Duration(seconds: seconds));

  static String? truncate(String? text, [int maxLen = 10]) {
    if (text == null) return text;
    if (text.length < (maxLen * 2)) return text;
    return text.substring(0, maxLen) + text.substring(text.length - maxLen);
  }

  /*static Future<String> getAppName() async {
    var value = '@todo';

    try {
      // https://github.com/fluttercommunity/plus_plugins/issues/214
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      value = packageInfo.appName.isEmpty ? 'Memento' : packageInfo.appName;
    } on Exception catch (_) {}

    return value;
  }*/

  static void nextTick(Function fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fn();
    });
  }

  static Future<void> nextTick2(Function fn, [int delayMillis = 100]) async {
    return Future.delayed(Duration(milliseconds: delayMillis), () => fn);
  }

  static Future<void> waitFor(bool Function() fn, [int delayMillis = 1000]) async {
    while (!fn()) {
      await Future.delayed(Duration(milliseconds: delayMillis));
    }
  }

  static T? getOrDefault<T>(T Function() fn, [T? defaultValue]) {
    try {
      return fn();
    } catch (e) {
      return defaultValue;
    }
  }

  static String getHashedUserAvatarUrl(String email) {
    // Hash the user's email with SHA256 so we don't leak it
    // Grab a random initial avatar for the user
    final avatarUrlBytes = utf8.encode(email);
    final avatarSha256 = sha256.convert(avatarUrlBytes);
    final avatarUrl = 'https://api.multiavatar.com/$avatarSha256}';
    return avatarUrl;
  }

  static String getAvatarUrlOrRandom(int? userId, String? email, {bool asSVG = false}) {
    // First check if we have an email, and try to use the Gravatar URL
    String? avatarUrl = email == null ? null : GravatarSource(email, 300).getAvatarUrl();

    // If email is empty or Gravatar is a 404, try setting a random avatar
    if (avatarUrl == null || avatarUrl.endsWith('404')) {
      // But only if we have an email
      if (email?.isNotEmpty == true) {
        avatarUrl = Utils.getHashedUserAvatarUrl(email!) + (asSVG ? '' : '.png');
      } else {
        // Otherwise WTF
        log.w("User doesn't have an email, so we can't set an avatar");
        // @todo something else here?
        final randomSeed = DateTime
            .now()
            .millisecondsSinceEpoch * Random.secure().nextInt(9999);
        final randomAvatarSeed = (userId?.toString() ?? randomSeed.toString()) + (asSVG ? '' : '.png');
        avatarUrl = Utils.getHashedUserAvatarUrl(randomAvatarSeed);
      }
    }

    return avatarUrl;
  }

  static String encodeStringToBase64UrlSafeString(final String url) => _base64SafeEncoder.encode(utf8.encode(url));

  static String decodeFromBase64UrlSafeEncodedString(String str) => utf8.decode(_base64SafeEncoder.decode(str));
}
