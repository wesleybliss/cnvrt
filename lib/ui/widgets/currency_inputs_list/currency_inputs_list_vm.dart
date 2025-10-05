import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/currency_values_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/sorted_currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/utils/currency_locales.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final currencyInputsListViewModelProvider = NotifierProvider<CurrencyInputsListViewModel, Map<String, TextEditingController>>(() {
  return CurrencyInputsListViewModel();
});

class CurrencyInputsListViewModel extends Notifier<Map<String, TextEditingController>> {
  final log = Logger('CurrencyInputsListViewModel');

  @override
  Map<String, TextEditingController> build() {
    // Initialize controllers for the initial list of currencies
    // This will be updated when sortedCurrenciesProvider changes in the UI
    final sortedCurrencies = ref.read(sortedCurrenciesProvider);
    final controllers = <String, TextEditingController>{};
    for (var currency in sortedCurrencies) {
      controllers[currency.symbol] = TextEditingController();
    }
    ref.onDispose(() {
      for (var controller in controllers.values) {
        controller.dispose();
      }
    });
    return controllers;
  }

  /// Clear all controllers when the focused input changes
  void clearAllInputs() {
    ref.read(currencyValuesProvider.notifier).clearValues();
  }

  String _formatCurrency(String symbol, double value) {
    // Access settings to determine if decimals are allowed
    final allowDecimalInput = ref.read(settingsNotifierProvider).value?.allowDecimalInput ?? false;

    final formatter = NumberFormat.currency(
      locale: currencyLocales[symbol] ?? 'en_US',
      symbol: '',
      decimalDigits: allowDecimalInput ? 2 : 0, // Set to 0 for whole numbers, 2 for decimals
    );

    // Use the actual double value for formatting
    return formatter.format(value).trim();
  }

  void onFocusChanged(String symbol) {
    state[symbol]?.clear();

    final focusedSymbol = ref.read(focusedCurrencyInputSymbolProvider);
    if (focusedSymbol == symbol) return;

    clearAllInputs();
    ref.read(focusedCurrencyInputSymbolProvider.notifier).setSymbol(symbol);
  }

  void updateControllers(Map<String, double> currencyValues) {
    log.d('updateControllers\n${currencyValues.entries.toString()}');

    final focusedCurrencyInputSymbol = ref.read(focusedCurrencyInputSymbolProvider);

    for (var entry in currencyValues.entries) {
      final symbol = entry.key;
      // Use the double value for formatting
      final value = _formatCurrency(symbol, entry.value);

      log.d(['DEBUG DEBUG DEBUG DEBUG: updateControllers $symbol => $value'].join('\n'));
      // Don't update the input field they've typed in
      if (focusedCurrencyInputSymbol == symbol) continue;

      if (state.containsKey(symbol)) {
        final controller = state[symbol]!;
        final valueAsString = value;

        log.d('updateControllers $symbol => ${controller.text} -> $valueAsString');
        // Update controller only if the value has changed
        if (controller.text != valueAsString) {
          controller.text = valueAsString;
        }
      } else {
        log.e('Currency not found: $symbol in ${state.keys}');
      }
    }
  }

  void onTextChanged(String symbol, String text) {
    if (text.isEmpty) {
      clearAllInputs();
      return;
    }
    final numericText = text.replaceAll(RegExp(r'[^0-9.]'), '');
    log.d('SET VALUE $symbol $text ($numericText)');
    ref.read(currencyValuesProvider.notifier).setValue(symbol, numericText);
    // The ref.listen in the widget will handle calling updateControllers
  }

  void onReorderCurrency(int oldIndex, int newIndex) {
    ref.read(sortedCurrenciesProvider.notifier).reorder(oldIndex, newIndex);
  }
}
