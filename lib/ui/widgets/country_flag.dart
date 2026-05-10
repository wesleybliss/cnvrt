import 'package:cnvrt/utils/logger.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

final log = Logger('buildCurrencyFlag');

const flagWidth = 20.0;
const flagHeight = 16.0;

enum BuildCurrencyFlagStyle { basic, emoji, circle, roundedRectangle }

Widget buildCurrencyFlag(
  String? currencyCode, {
  double opacity = 0.50,
  BuildCurrencyFlagStyle style = BuildCurrencyFlagStyle.basic,
}) {
  log.d("currencyCode: $currencyCode");

  if (currencyCode == null || currencyCode.isEmpty) {
    return const Text("💱", style: TextStyle(fontSize: flagHeight));
  }

  final theme = switch (style) {
    BuildCurrencyFlagStyle.emoji => EmojiTheme(size: flagWidth),
    BuildCurrencyFlagStyle.circle => const ImageTheme(
      shape: Circle(),
      width: flagWidth,
      height: flagHeight,
    ),
    BuildCurrencyFlagStyle.roundedRectangle => ImageTheme(
      shape: RoundedRectangle(2),
      width: flagWidth,
      height: flagHeight,
    ),
    _ => const ImageTheme(width: flagWidth, height: flagHeight),
  };

  return Opacity(
    opacity: opacity,
    child: CountryFlag.fromCurrencyCode(currencyCode, theme: theme),
  );
}
