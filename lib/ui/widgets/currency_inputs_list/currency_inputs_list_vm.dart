import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/currency_values_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/sorted_currencies_provider.dart';
import 'package:cnvrt/utils/currency_locales.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CurrencyInputsListViewModelState {
  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;

  CurrencyInputsListViewModelState({required this.controllers, required this.focusNodes});
}

final currencyInputsListViewModelProvider =
    NotifierProvider<CurrencyInputsListViewModel, CurrencyInputsListViewModelState>(() {
      return CurrencyInputsListViewModel();
    });

class CurrencyInputsListViewModel extends Notifier<CurrencyInputsListViewModelState> {
  final log = Logger('CurrencyInputsListViewModel');

  // Cache controllers and focus nodes to prevent focus loss during rebuilds
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  bool _onDisposeRegistered = false;

  @override
  CurrencyInputsListViewModelState build() {
    // Watch sortedCurrenciesProvider so this rebuilds when currencies change
    final sortedCurrencies = ref.watch(sortedCurrenciesProvider);
    
    // Register cleanup once
    if (!_onDisposeRegistered) {
      _onDisposeRegistered = true;
      ref.onDispose(() {
        log.d('Cleaning up all controllers and focusNodes');
        for (var controller in _controllers.values) {
          controller.dispose();
        }
        for (var focusNode in _focusNodes.values) {
          focusNode.dispose();
        }
        _controllers.clear();
        _focusNodes.clear();
      });
    }

    final currentSymbols = sortedCurrencies.map((e) => e.symbol).toSet();

    // 1. Dispose and remove controllers/nodes for currencies no longer present
    final symbolsToRemove = _controllers.keys.where((s) => !currentSymbols.contains(s)).toList();
    for (final symbol in symbolsToRemove) {
      log.d('Disposing controller and focusNode for $symbol');
      _controllers[symbol]?.dispose();
      _focusNodes[symbol]?.dispose();
      _controllers.remove(symbol);
      _focusNodes.remove(symbol);
    }

    // 2. Create or reuse controllers/nodes for current currencies
    for (var currency in sortedCurrencies) {
      final symbol = currency.symbol;
      if (!_controllers.containsKey(symbol)) {
        log.d('Creating new controller and focusNode for $symbol');
        _controllers[symbol] = TextEditingController();
        final focusNode = FocusNode();
        _focusNodes[symbol] = focusNode;

        // Listen to focus changes and update the provider
        focusNode.addListener(() {
          if (focusNode.hasFocus) {
            onFocusChanged(symbol);
          }
        });
      }
    }

    log.d('build() state with: ${_controllers.keys.join(", ")}');

    return CurrencyInputsListViewModelState(
      controllers: Map.unmodifiable(_controllers),
      focusNodes: Map.unmodifiable(_focusNodes),
    );
  }

  /// Request focus on the first currency input
  void requestFocusOnFirst() {
    final sortedCurrencies = ref.read(sortedCurrenciesProvider);
    if (sortedCurrencies.isEmpty) return;
    requestFocus(sortedCurrencies.first.symbol);
  }

  /// Request focus on a specific currency input by its symbol
  void requestFocus(String symbol) {
    final focusNode = _focusNodes[symbol];

    if (focusNode != null) {
      log.d('Requesting focus on $symbol');
      // Use a slight delay to ensure the widget tree is fully built
      Future.delayed(const Duration(milliseconds: 100), () {
        if (focusNode.canRequestFocus) {
          focusNode.requestFocus();
        }
      });
    }
  }

  /// Clear all controllers when the focused input changes
  void clearAllInputs() {
    ref.read(currencyValuesProvider.notifier).clearValues();
  }

  void onFocusChanged(String symbol) {
    state.controllers[symbol]?.clear();

    final focusedSymbol = ref.read(focusedCurrencyInputSymbolProvider);
    if (focusedSymbol == symbol) return;

    clearAllInputs();
    ref.read(focusedCurrencyInputSymbolProvider.notifier).setSymbol(symbol);
  }

  void updateControllers(
    Map<String, double> currencyValues,
    String? focusedCurrencyInputSymbol,
    bool allowDecimalInput,
  ) {
    log.d('updateControllers\n${currencyValues.entries.toString()}');

    for (var entry in currencyValues.entries) {
      final symbol = entry.key;
      // Use the double value for formatting
      final value = _formatCurrencyWithSettings(symbol, entry.value, allowDecimalInput);

      // Don't update the input field they've typed in
      if (focusedCurrencyInputSymbol == symbol) continue;

      if (state.controllers.containsKey(symbol)) {
        final controller = state.controllers[symbol]!;
        final valueAsString = value;

        log.d('updateControllers $symbol => ${controller.text} -> $valueAsString');
        // Update controller only if the value has changed
        if (controller.text != valueAsString) {
          controller.text = valueAsString;
        }
      } else {
        log.e('Currency not found: $symbol in ${state.controllers.keys}');
      }
    }
  }

  String _formatCurrencyWithSettings(String symbol, double value, bool allowDecimalInput) {
    final formatter = NumberFormat.currency(
      locale: currencyLocales[symbol] ?? 'en_US',
      symbol: '',
      decimalDigits: allowDecimalInput ? 2 : 0, // Set to 0 for whole numbers, 2 for decimals
    );

    // Use the actual double value for formatting
    return formatter.format(value).trim();
  }

  void onTextChanged(String symbol, String text) {
    if (text.isEmpty) {
      clearAllInputs();
      return;
    }
    final numericText = text.replaceAll(RegExp(r'[^0-9.]'), '');
    log.d('SET VALUE $symbol $text ($numericText)');
    ref.read(currencyValuesProvider.notifier).setValue(symbol, numericText);
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
