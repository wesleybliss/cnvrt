import 'package:cnvrt/io/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<Settings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return Settings.fromPreferences(prefs);
  }

  Future<void> updateSettings(Settings newSettings) async {
    // Important: use state.update to preserve the previous state while updating
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await newSettings.saveToPreferences(prefs);
      return newSettings;
    });
  }

  Future<void> setTheme(String value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(theme: value);
    await updateSettings(newSettings);
  }

  Future<void> setLanguage(String value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(language: value);
    await updateSettings(newSettings);
  }

  Future<void> setLastUpdated(DateTime value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(lastUpdated: value);
    await updateSettings(newSettings);
  }

  Future<void> setUpdateFrequencyInHours(int value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(updateFrequencyInHours: value);
    await updateSettings(newSettings);
  }

  Future<void> setRoundingDecimals(int value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(roundingDecimals: value);
    await updateSettings(newSettings);
  }

  Future<void> setUseLargeInputs(bool value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(useLargeInputs: !currentSettings.useLargeInputs);
    await updateSettings(newSettings);
  }

  Future<void> setDragReorderHandles(bool value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(showDragReorderHandles: !currentSettings.showDragReorderHandles);
    await updateSettings(newSettings);
  }

  Future<void> setShowCopyToClipboardButtons(bool value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(
      showCopyToClipboardButtons: !currentSettings.showCopyToClipboardButtons,
    );
    await updateSettings(newSettings);
  }

  Future<void> setShowFullCurrencyNameLabel(bool value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(showFullCurrencyNameLabel: !currentSettings.showFullCurrencyNameLabel);
    await updateSettings(newSettings);
  }

  Future<void> setInputsPosition(String value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(inputsPosition: value);
    await updateSettings(newSettings);
  }

  Future<void> setShowCurrencyRate(String value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(showCurrencyRate: value);
    await updateSettings(newSettings);
  }

  Future<void> setAccountForInflation(bool value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(accountForInflation: !currentSettings.accountForInflation);
    await updateSettings(newSettings);
  }

  Future<void> setShowCountryFlags(bool value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(showCountryFlags: !currentSettings.showCountryFlags);
    await updateSettings(newSettings);
  }

  Future<void> setAllowDecimalInput(bool value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(allowDecimalInput: !currentSettings.allowDecimalInput);
    await updateSettings(newSettings);
  }

  Future<void> setDeveloperModeActive(bool value) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(developerModeActive: !currentSettings.developerModeActive);
    await updateSettings(newSettings);
  }

  //region Utilities

  void setThemeMode(ThemeMode newThemeMode) {
    setTheme(
      newThemeMode == ThemeMode.system
          ? "system"
          : newThemeMode == ThemeMode.light
          ? "light"
          : "dark",
    );
  }

  void cycleNextTheme() {
    if (state.value?.theme == "system") {
      setThemeMode(getSystemBrightness() == Brightness.light ? ThemeMode.dark : ThemeMode.light);
    } else if (state.value?.theme == "light") {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.system);
    }
  }

  // Detect the current system brightness
  Brightness getSystemBrightness() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }

  //endregion Utilities
}
