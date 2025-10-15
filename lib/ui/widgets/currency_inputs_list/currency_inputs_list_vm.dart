import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/currency_values_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/sorted_currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/utils/currency_locales.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CurrencyInputsListViewModelState {
  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;

  CurrencyInputsListViewModelState({
    required this.controllers,
    required this.focusNodes,
  });
}

final currencyInputsListViewModelProvider = NotifierProvider<
  CurrencyInputsListViewModel,
  CurrencyInputsListViewModelState
>(() {
  return CurrencyInputsListViewModel();
});

class CurrencyInputsListViewModel
    extends Notifier<CurrencyInputsListViewModelState> {
  final log = Logger('CurrencyInputsListViewModel');

  @override
  CurrencyInputsListViewModelState build() {
    // Watch sortedCurrenciesProvider so this rebuilds when currencies change
    final sortedCurrencies = ref.watch(sortedCurrenciesProvider);
    final controllers = <String, TextEditingController>{};
    final focusNodes = <String, FocusNode>{};

    for (var currency in sortedCurrencies) {
      controllers[currency.symbol] = TextEditingController();
      final focusNode = FocusNode();
      focusNodes[currency.symbol] = focusNode;

      // Listen to focus changes and update the provider
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          onFocusChanged(currency.symbol);
        }
      });
    }

    ref.onDispose(() {
      for (var controller in controllers.values) {
        controller.dispose();
      }
      for (var focusNode in focusNodes.values) {
        focusNode.dispose();
      }
    });

    log.d('build() created controllers for: ${controllers.keys.join(", ")}');

    return CurrencyInputsListViewModelState(
      controllers: controllers,
      focusNodes: focusNodes,
    );
  }

  /// Request focus on the first currency input
  void requestFocusOnFirst() {
    final sortedCurrencies = ref.read(sortedCurrenciesProvider);
    if (sortedCurrencies.isEmpty) return;

    final firstSymbol = sortedCurrencies.first.symbol;
    final focusNode = state.focusNodes[firstSymbol];

    if (focusNode != null) {
      // Use a slight delay to ensure the widget tree is fully built
      Future.delayed(const Duration(milliseconds: 100), () {
        focusNode.requestFocus();
      });
    }
  }

  /// Clear all controllers when the focused input changes
  void clearAllInputs() {
    ref.read(currencyValuesProvider.notifier).clearValues();
  }

  String _formatCurrency(String symbol, double value) {
    // Access settings to determine if decimals are allowed
    final allowDecimalInput =
        ref.read(settingsNotifierProvider).value?.allowDecimalInput ?? false;

    final formatter = NumberFormat.currency(
      locale: currencyLocales[symbol] ?? 'en_US',
      symbol: '',
      decimalDigits:
          allowDecimalInput
              ? 2
              : 0, // Set to 0 for whole numbers, 2 for decimals
    );

    // Use the actual double value for formatting
    return formatter.format(value).trim();
  }

  void onFocusChanged(String symbol) {
    state.controllers[symbol]?.clear();

    final focusedSymbol = ref.read(focusedCurrencyInputSymbolProvider);
    if (focusedSymbol == symbol) return;

    clearAllInputs();
    ref.read(focusedCurrencyInputSymbolProvider.notifier).setSymbol(symbol);
  }

  void updateControllers(Map<String, double> currencyValues) {
    log.d('updateControllers\n${currencyValues.entries.toString()}');

    final focusedCurrencyInputSymbol = ref.read(
      focusedCurrencyInputSymbolProvider,
    );

    for (var entry in currencyValues.entries) {
      final symbol = entry.key;
      // Use the double value for formatting
      final value = _formatCurrency(symbol, entry.value);

      log.d(
        [
          'DEBUG DEBUG DEBUG DEBUG: updateControllers $symbol => $value',
        ].join('\n'),
      );
      // Don't update the input field they've typed in
      if (focusedCurrencyInputSymbol == symbol) continue;

      if (state.controllers.containsKey(symbol)) {
        final controller = state.controllers[symbol]!;
        final valueAsString = value;

        log.d(
          'updateControllers $symbol => ${controller.text} -> $valueAsString',
        );
        // Update controller only if the value has changed
        if (controller.text != valueAsString) {
          controller.text = valueAsString;
        }
      } else {
        log.e('Currency not found: $symbol in ${state.controllers.keys}');
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
    if (newIndex > oldIndex) newIndex -= 1;

    final sortedCurrencies = ref.read(sortedCurrenciesProvider);
    final reordered = List<Currency>.from(sortedCurrencies);
    final item = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, item);

    // Update order properties and persist to disk
    for (int i = 0; i < reordered.length; i++) {
      final updatedCurrency = reordered[i].copyWith(order: i);
      ref.read(currenciesProvider.notifier).setCurrency(updatedCurrency);
    }
  }
}
