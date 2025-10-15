import 'package:shared_preferences/shared_preferences.dart';

abstract class ISettings {
  abstract String theme;
  abstract String language;
  abstract DateTime? lastUpdated;
  abstract int updateFrequencyInHours;
  abstract int roundingDecimals;
  abstract bool useLargeInputs;
  abstract bool showDragReorderHandles;
  abstract bool showCopyToClipboardButtons;
  abstract bool showFullCurrencyNameLabel;
  abstract String inputsPosition;
  abstract String showCurrencyRate;
  abstract bool showCountryFlags;
  abstract bool accountForInflation;
  abstract bool allowDecimalInput;
  abstract bool disableCurrencyCaching;

  // If the user has tapped the version number 10 times, we enable developer mode
  abstract bool developerModeActive;

  ISettings copyWith({
    String? theme,
    String? language,
    DateTime? lastUpdated,
    int? updateFrequencyInHours,
    int? roundingDecimals,
    bool? useLargeInputs,
    bool? showDragReorderHandles,
    bool? showCopyToClipboardButtons,
    bool? showFullCurrencyNameLabel,
    String? inputsPosition,
    String? showCurrencyRate,
    bool? accountForInflation,
    bool? showCountryFlags,
    bool? allowDecimalInput,
    bool? disableCurrencyCaching,

    bool? developerModeActive,
  });

  Future<void> saveToPreferences(SharedPreferences prefs);
}
