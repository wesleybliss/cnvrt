import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/sorted_currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/utils/currency_utils.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyValuesNotifier extends StateNotifier<Map<String, double>> {
  final log = Logger('CurrencyValuesNotifier');
  final Ref ref;

  CurrencyValuesNotifier(this.ref) : super({}) {
    // Initialize once with the currently selected currencies, preserving any
    // values that may already exist. We intentionally do NOT depend on
    // selectedCurrenciesProvider inside the create function, because that would
    // recreate this notifier (resetting all values to 0.0) every time the
    // currencies get refreshed in the background — which is the bug that caused
    // the non-focused inputs to be cleared on refresh.
    _syncSelected(ref.read(selectedCurrenciesProvider));

    // Keep the values in sync with selection changes (add/remove), but preserve
    // existing values so background refreshes never disturb the current UI state.
    ref.listen<List<Currency>>(selectedCurrenciesProvider, (_, next) {
      _syncSelected(next);
    });
  }

  // Add newly selected currencies and drop deselected ones, preserving any
  // values that are still present. This keeps conversions intact across refreshes.
  void _syncSelected(List<Currency> selectedCurrencies) {
    final newState = Map<String, double>.from(state);
    final selectedSymbols = selectedCurrencies.map((c) => c.symbol).toSet();

    newState.removeWhere((symbol, _) => !selectedSymbols.contains(symbol));

    for (final currency in selectedCurrencies) {
      newState.putIfAbsent(currency.symbol, () => 0.0);
    }

    state = newState;
  }

  void clearValues() {
    for (var currency in state.keys) {
      state[currency] = 0.0;
    }
  }

  // Update the value for a specific currency
  Map<String, double> setValue(
    String symbol,
    String text, {
    updateSelf = true,
  }) {
    final raw = removeAllButLastDecimal(text);
    final double value = double.tryParse(raw) ?? 0.0;
    final sortedCurrencies = ref.read(sortedCurrenciesProvider);
    final settings = ref.read(settingsNotifierProvider).value;

    // If settings haven't loaded yet, use default values to prevent crashes
    if (settings == null) {
      log.w('Settings not loaded yet, skipping conversion');
      return state;
    }

    // log.d('convertCurrencies: RAW: $text -> $raw -> ${sortedCurrencies.join(', ')}');

    // Get the updated currency values
    state = convertCurrencies(symbol, value, sortedCurrencies, settings);

    return state;
  }

  // Recompute all conversions using the current focused input's value and the
  // latest rates. Called after a background currency refresh so the displayed
  // converted values stay accurate without disturbing the user's current input.
  void recomputeWithLatestRates() {
    final sortedCurrencies = ref.read(sortedCurrenciesProvider);
    final settings = ref.read(settingsNotifierProvider).value;
    if (settings == null || sortedCurrencies.isEmpty) return;

    final focusedSymbol = ref.read(focusedCurrencyInputSymbolProvider);
    if (focusedSymbol == null) return;

    // Use the last computed value for the focused symbol as the source amount.
    // The stored value already reflects any inflation adjustment (e.g. COP
    // "1234" is stored as 1,234,000), so we must NOT apply inflation again —
    // otherwise it would be multiplied by 1000 a second time after a refresh.
    final sourceValue = state[focusedSymbol] ?? 0.0;
    if (sourceValue == 0.0) return;

    state = convertCurrencies(
      focusedSymbol,
      sourceValue,
      sortedCurrencies,
      settings,
      accountForInflation: false,
    );
  }
}

final currencyValuesProvider =
    StateNotifierProvider<CurrencyValuesNotifier, Map<String, double>>((ref) {
      // Create the notifier. It reads the selected currencies itself (inside
      // build) so it is NOT recreated when the currencies list refreshes in
      // the background — only when the provider is truly disposed.
      return CurrencyValuesNotifier(ref);
    });
