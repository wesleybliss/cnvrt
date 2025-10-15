import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/domain/io/i_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings implements ISettings {
  @override
  String theme = "system";
  @override
  String language = "system";
  @override
  DateTime? lastUpdated;
  @override
  int updateFrequencyInHours = 12;
  @override
  int roundingDecimals = 2;
  @override
  bool useLargeInputs = false;
  @override
  bool showDragReorderHandles = true;
  @override
  bool showCopyToClipboardButtons = true;
  @override
  bool showFullCurrencyNameLabel = true;
  @override
  String inputsPosition = "center";
  @override
  String showCurrencyRate = "selected";
  @override
  bool accountForInflation = true;
  @override
  bool showCountryFlags = true;
  @override
  bool allowDecimalInput = false;
  @override
  bool disableCurrencyCaching = false;

  @override
  bool developerModeActive = false;

  Settings({
    this.theme = "system",
    this.language = "system",
    this.lastUpdated,
    this.updateFrequencyInHours = 12,
    this.roundingDecimals = 2,
    this.useLargeInputs = false,
    this.showDragReorderHandles = true,
    this.showCopyToClipboardButtons = true,
    this.showFullCurrencyNameLabel = true,
    this.inputsPosition = "center",
    this.showCurrencyRate = "selected",
    this.accountForInflation = true,
    this.showCountryFlags = true,
    this.allowDecimalInput = false,
    this.disableCurrencyCaching = false,

    this.developerModeActive = false,
  });

  @override
  Settings copyWith({
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
  }) => Settings(
    theme: theme ?? this.theme,
    language: language ?? this.language,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    updateFrequencyInHours: updateFrequencyInHours ?? this.updateFrequencyInHours,
    roundingDecimals: roundingDecimals ?? this.roundingDecimals,
    useLargeInputs: useLargeInputs ?? this.useLargeInputs,
    showDragReorderHandles: showDragReorderHandles ?? this.showDragReorderHandles,
    showCopyToClipboardButtons: showCopyToClipboardButtons ?? this.showCopyToClipboardButtons,
    showFullCurrencyNameLabel: showFullCurrencyNameLabel ?? this.showFullCurrencyNameLabel,
    inputsPosition: inputsPosition ?? this.inputsPosition,
    showCurrencyRate: showCurrencyRate ?? this.showCurrencyRate,
    accountForInflation: accountForInflation ?? this.accountForInflation,
    showCountryFlags: showCountryFlags ?? this.showCountryFlags,
    allowDecimalInput: allowDecimalInput ?? this.allowDecimalInput,
    disableCurrencyCaching: disableCurrencyCaching ?? this.disableCurrencyCaching,

    developerModeActive: developerModeActive ?? this.developerModeActive,
  );

  // Factory method to create a Settings object from SharedPreferences
  factory Settings.fromPreferences(SharedPreferences prefs) {
    final keys = Constants.keys.settings;

    return Settings(
      theme: prefs.getString(keys.theme) ?? "system",
      language: prefs.getString(keys.language) ?? "system",
      lastUpdated:
          prefs.getString(keys.lastUpdated) != null ? DateTime.parse(prefs.getString(keys.lastUpdated)!) : null,
      updateFrequencyInHours: prefs.getInt(keys.updateFrequencyInHours) ?? 12,
      roundingDecimals: prefs.getInt(keys.roundingDecimals) ?? 4,
      useLargeInputs: prefs.getInt(keys.useLargeInputs) == 1,
      showDragReorderHandles: prefs.getInt(keys.showDragReorderHandles) == 1,
      showCopyToClipboardButtons: prefs.getInt(keys.showCopyToClipboardButtons) == 1,
      showFullCurrencyNameLabel: prefs.getInt(keys.showFullCurrencyNameLabel) == 1,
      inputsPosition: prefs.getString(keys.inputsPosition) ?? "center",
      showCurrencyRate: prefs.getString(keys.showCurrencyRate) ?? "selected",
      accountForInflation: prefs.getBool(keys.accountForInflation) ?? true,
      showCountryFlags: prefs.getBool(keys.showCountryFlags) ?? true,
      allowDecimalInput: prefs.getBool(keys.allowDecimalInput) ?? false,
      disableCurrencyCaching: prefs.getBool(keys.disableCurrencyCaching) ?? false,

      developerModeActive: prefs.getBool(keys.developerModeActive) ?? false,
    );
  }

  // Method to save the settings to SharedPreferences
  @override
  Future<void> saveToPreferences(SharedPreferences prefs) async {
    final keys = Constants.keys.settings;

    await prefs.setString(keys.theme, theme);
    await prefs.setString(keys.language, language);

    if (lastUpdated != null) {
      await prefs.setString(keys.lastUpdated, lastUpdated!.toIso8601String());
    }

    await prefs.setInt(keys.updateFrequencyInHours, updateFrequencyInHours);
    await prefs.setInt(keys.roundingDecimals, roundingDecimals);
    await prefs.setInt(keys.useLargeInputs, useLargeInputs ? 1 : 0);
    await prefs.setInt(keys.showDragReorderHandles, showDragReorderHandles ? 1 : 0);
    await prefs.setInt(keys.showCopyToClipboardButtons, showCopyToClipboardButtons ? 1 : 0);
    await prefs.setInt(keys.showFullCurrencyNameLabel, showFullCurrencyNameLabel ? 1 : 0);
    await prefs.setString(keys.inputsPosition, inputsPosition);
    await prefs.setString(keys.showCurrencyRate, showCurrencyRate);
    await prefs.setBool(keys.accountForInflation, accountForInflation);
    await prefs.setBool(keys.showCountryFlags, showCountryFlags);
    await prefs.setBool(keys.allowDecimalInput, allowDecimalInput);
    await prefs.setBool(keys.disableCurrencyCaching, disableCurrencyCaching);

    await prefs.setBool(keys.developerModeActive, developerModeActive);
  }
}
