import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/currency_values_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/sorted_currencies_provider.dart';
import 'package:cnvrt/utils/currency_locales.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final log = Logger('CurrencyInputsListViewModel');

@immutable
class CurrencyInputsListViewModelState {
  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;

  const CurrencyInputsListViewModelState({
    required this.controllers,
    required this.focusNodes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyInputsListViewModelState &&
          runtimeType == other.runtimeType &&
          mapEquals(controllers, other.controllers) &&
          mapEquals(focusNodes, other.focusNodes);

  @override
  int get hashCode => controllers.hashCode ^ focusNodes.hashCode;
}

final currencyInputsListViewModelProvider =
    NotifierProvider<
      CurrencyInputsListViewModel,
      CurrencyInputsListViewModelState
    >(() {
      return CurrencyInputsListViewModel();
    });

class CurrencyInputsListViewModel
    extends Notifier<CurrencyInputsListViewModelState> {
  // Cache controllers and focus nodes to prevent focus loss during rebuilds
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  bool _onDisposeRegistered = false;

  @override
  CurrencyInputsListViewModelState build() {
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

      // Sync controllers reactively without triggering build() re-runs.
      // Using ref.listen (not ref.watch) keeps build() as a one-shot init,
      // so ref.onDispose above only fires at true provider disposal —
      // not on every currency refresh.
      ref.listen<List<Currency>>(sortedCurrenciesProvider, (_, currencies) {
        if (_syncControllers(currencies)) {
          state = CurrencyInputsListViewModelState(
            controllers: Map.from(_controllers),
            focusNodes: Map.from(_focusNodes),
          );
        }
      });
    }

    _syncControllers(ref.read(sortedCurrenciesProvider));

    return CurrencyInputsListViewModelState(
      controllers: Map.from(_controllers),
      focusNodes: Map.from(_focusNodes),
    );
  }

  // Returns true if controllers were added or removed.
  bool _syncControllers(List<Currency> currencies) {
    final currentSymbols = currencies.map((e) => e.symbol).toSet();
    bool changed = false;

    final symbolsToRemove = _controllers.keys
        .where((s) => !currentSymbols.contains(s))
        .toList();
    for (final symbol in symbolsToRemove) {
      log.d('Disposing controller and focusNode for $symbol');
      _controllers[symbol]?.dispose();
      _focusNodes[symbol]?.dispose();
      _controllers.remove(symbol);
      _focusNodes.remove(symbol);
      changed = true;
    }

    for (var currency in currencies) {
      final symbol = currency.symbol;
      if (!_controllers.containsKey(symbol)) {
        log.d('Creating new controller and focusNode for $symbol');
        _controllers[symbol] = TextEditingController();
        final focusNode = FocusNode();
        _focusNodes[symbol] = focusNode;
        focusNode.addListener(() {
          if (focusNode.hasFocus) {
            onFocusChanged(symbol);
          }
        });
        changed = true;
      }
    }

    return changed;
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
    if (focusNode == null) return;
    log.d(
      'DEBUG requestFocus: symbol=$symbol hasFocus=${focusNode.hasFocus} controllerText=${_controllers[symbol]?.text}',
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      log.d(
        'DEBUG requestFocus delayed: symbol=$symbol hasFocus=${focusNode.hasFocus} canRequestFocus=${focusNode.canRequestFocus}',
      );
      if (focusNode.canRequestFocus && !focusNode.hasFocus) {
        log.d(
          'DEBUG requestFocus: calling focusNode.requestFocus() for $symbol',
        );
        focusNode.requestFocus();
      }
    });
  }

  /// Clear all controllers when the focused input changes
  void clearAllInputs() {
    ref.read(currencyValuesProvider.notifier).clearValues();
  }

  void onFocusChanged(String symbol) {
    final focusedSymbol = ref.read(focusedCurrencyInputSymbolProvider);
    log.d(
      'DEBUG onFocusChanged: symbol=$symbol focusedSymbol=$focusedSymbol controllerText=${state.controllers[symbol]?.text}',
    );
    if (focusedSymbol == symbol) {
      log.d('DEBUG onFocusChanged: same symbol, returning early');
      return;
    }

    log.d('DEBUG onFocusChanged: clearing controller for $symbol');
    state.controllers[symbol]?.clear();
    clearAllInputs();
    ref.read(focusedCurrencyInputSymbolProvider.notifier).setSymbol(symbol);
  }

  void updateControllers(
    Map<String, double> currencyValues,
    bool allowDecimalInput,
  ) {
    final focusedSymbol = ref.read(focusedCurrencyInputSymbolProvider);
    log.d(
      'DEBUG updateControllers: focusedSymbol=$focusedSymbol values=${currencyValues.entries.map((e) => "${e.key}:${e.value}").join(", ")}',
    );

    for (var entry in currencyValues.entries) {
      final symbol = entry.key;
      final value = _formatCurrencyWithSettings(
        symbol,
        entry.value,
        allowDecimalInput,
      );

      if (focusedSymbol == symbol) continue;

      if (state.controllers.containsKey(symbol)) {
        final controller = state.controllers[symbol]!;
        final valueAsString = value;

        if (controller.text != valueAsString) {
          log.d(
            'DEBUG updateControllers: setting $symbol controller to "$valueAsString" (was "${controller.text}")',
          );
          controller.text = valueAsString;
        }
      }
    }
  }

  String _formatCurrencyWithSettings(
    String symbol,
    double value,
    bool allowDecimalInput,
  ) {
    final formatter = NumberFormat.currency(
      locale: currencyLocales[symbol] ?? 'en_US',
      symbol: '',
      decimalDigits: allowDecimalInput
          ? 2
          : 0, // Set to 0 for whole numbers, 2 for decimals
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
