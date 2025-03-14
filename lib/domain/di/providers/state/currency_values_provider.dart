import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/domain/di/providers/sorted_currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/state/currencies_provider.dart';
import 'package:cnvrt/domain/models/currency.dart';
import 'package:cnvrt/utils/currency_utils.dart';
import 'package:cnvrt/utils/logger.dart';

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
    final double value = double.tryParse(text) ?? 0.0;
    final sortedCurrencies = ref.read(sortedCurrenciesProvider);

    log.d('DEBUG DEBUG: convertCurrencies: ${sortedCurrencies.join(', ')}');

    // Get the updated currency values
    // state = convertCurrencies(symbol, value, sortedCurrencies);
    final next = convertCurrencies(symbol, value, sortedCurrencies);

    /*if (!updateSelf) {
      next.removeWhere((key, value) => key == symbol);
    }*/

    state = next;

    return state;
  }
}

final currencyValuesProvider = StateNotifierProvider<CurrencyValuesNotifier, Map<String, double>>(
  (ref) {
    // Get the list of selected currencies
    final selectedCurrencies = ref.watch(selectedCurrenciesProvider);

    // Create the notifier with the initial values
    return CurrencyValuesNotifier(selectedCurrencies, ref);
  },
);
