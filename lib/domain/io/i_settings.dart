import 'package:shared_preferences/shared_preferences.dart';

abstract class ISettings {
  abstract String theme;
  abstract DateTime? lastUpdated;
  abstract int updateFrequencyInHours;
  abstract int roundingDecimals;
  abstract bool showDragReorderHandles;
  abstract bool showCopyToClipboardButtons;
  abstract bool showFullCurrencyNameLabel;
  abstract String inputsPosition;
  abstract String showCurrencyRate;

  ISettings copyWith({
    String? theme,
    DateTime? lastUpdated,
    int? updateFrequencyInHours,
    int? roundingDecimals,
    bool? showDragReorderHandles,
    bool? showCopyToClipboardButtons,
    bool? showFullCurrencyNameLabel,
    String? inputsPosition,
    String? showCurrencyRate,
  });

  Future<void> saveToPreferences(SharedPreferences prefs);
}
