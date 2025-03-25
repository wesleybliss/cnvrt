import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/di/providers/sorted_currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/state/currencies_provider.dart';
import 'package:cnvrt/utils/currency_utils.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyValuesNotifier extends StateNotifier<Map<String, double>> {
  final log = Logger('CurrencyValuesNotifier');
  final Ref ref;

  CurrencyValuesNotifier(List<Currency> initialCurrencies, this.ref)
    : super(
        // Initialize with the selected currencies and default values (e.g., 0.0)
        {for (var currency in initialCurrencies) currency.symbol: 0.0},
      );

  void clearValues() {
    for (var currency in state.keys) {
      state[currency] = 0.0;
    }
  }

  // Update the value for a specific currency
  Map<String, double> setValue(String symbol, String text, {updateSelf = true}) {
    final raw = removeAllButLastDecimal(text);
    final double value = double.tryParse(raw) ?? 0.0;
    final sortedCurrencies = ref.read(sortedCurrenciesProvider);

    // log.d('convertCurrencies: RAW: $text -> $raw -> ${sortedCurrencies.join(', ')}');

    // Get the updated currency values)
    state = convertCurrencies(symbol, value, sortedCurrencies);

    return state;
  }
}

final currencyValuesProvider = StateNotifierProvider<CurrencyValuesNotifier, Map<String, double>>((ref) {
  // Get the list of selected currencies
  final selectedCurrencies = ref.watch(selectedCurrenciesProvider);

  // Create the notifier with the initial values
  return CurrencyValuesNotifier(selectedCurrencies, ref);
});
