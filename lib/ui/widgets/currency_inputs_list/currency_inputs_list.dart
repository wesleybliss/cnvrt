import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/domain/di/providers/settings_provider.dart';
import 'package:cnvrt/domain/di/providers/sorted_currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/state/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/state/currency_values_provider.dart';
import 'package:cnvrt/domain/models/currency.dart';
import 'package:cnvrt/ui/widgets/currency_inputs_list/currency_inputs_list_row.dart';
import 'package:cnvrt/utils/logger.dart';

class CurrenciesInputsList extends ConsumerStatefulWidget {
  final List<Currency> currencies;

  const CurrenciesInputsList({super.key, required this.currencies});

  @override
  ConsumerState<CurrenciesInputsList> createState() => _CurrenciesInputsListState();
}

class _CurrenciesInputsListState extends ConsumerState<CurrenciesInputsList> {
  final log = Logger('CurrenciesInputsList');
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Clear all controllers when the focused input changes
  void clearAllInputs() {
    ref.read(currencyValuesProvider.notifier).clearValues();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsyncValue = ref.watch(settingsNotifierProvider);
    final sortedCurrencies = ref.watch(sortedCurrenciesProvider);
    final currencyValues = ref.watch(currencyValuesProvider);

    // Track the focused input so we can clear them all when it changes
    final focusedCurrencyInputSymbol = ref.watch(focusedCurrencyInputSymbolProvider);

    for (var currency in sortedCurrencies) {
      _controllers.putIfAbsent(currency.symbol, () => TextEditingController());
    }

    void onFocusChanged(String symbol) {
      _controllers[symbol]?.clear();

      if (focusedCurrencyInputSymbol == symbol) return;

      clearAllInputs();
      ref.read(focusedCurrencyInputSymbolProvider.notifier).setSymbol(symbol);
    }

    void updateControllers(Map<String, double> currencyValues) {
      log.d('updateControllers\n${currencyValues.entries.toString()}');

      for (var entry in currencyValues.entries) {
        final symbol = entry.key;
        final value = entry.value;
        log.d(['DEBUG DEBUG DEBUG DEBUG: updateControllers $symbol => $value'].join('\n'));
        // Don't update the input field they've typed in
        if (focusedCurrencyInputSymbol == symbol) continue;

        if (_controllers.containsKey(symbol)) {
          final controller = _controllers[symbol]!;
          final valueAsString = value.toStringAsFixed(2); // @todo make this configurable

          log.d('updateControllers $symbol => ${controller.text} -> $valueAsString');
          // Update controller only if the value has changed
          if (controller.text != valueAsString) {
            controller.text = valueAsString;
          }
        } else {
          log.e('Currency not found: $symbol in ${_controllers.keys}');
        }
      }
    }

    // Update the controllers with the latest currency values
    updateControllers(currencyValues);

    void onTextChanged(String symbol, String text) {
      // If the text is empty, clear all controllers
      if (text.isEmpty) {
        clearAllInputs();
        return;
      }

      final updatedValues = ref.read(currencyValuesProvider.notifier).setValue(symbol, text);

      updateControllers(updatedValues);
    }

    void onReorderCurrency(int oldIndex, int newIndex) {
      setState(() {
        if (newIndex > oldIndex) newIndex -= 1; // Adjust for removal
        final item = sortedCurrencies.removeAt(oldIndex);
        sortedCurrencies.insert(newIndex, item);

        // Update the order property and save to ObjectBox
        for (int i = 0; i < sortedCurrencies.length; i++) {
          sortedCurrencies[i].order = i;
          ref.read(currenciesProvider.notifier).setCurrency(sortedCurrencies[i]);
        }
      });
    }

    return settingsAsyncValue.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Error: $error'),
        data: (settings) {
          return ReorderableListView(
            shrinkWrap: true,
            onReorder: onReorderCurrency,
            children: sortedCurrencies
                .map((e) => ListTile(
                      key: ValueKey(e.symbol),
                      leading: settings.showDragReorderHandles ? const Icon(Icons.drag_handle) : null,
                      title: CurrencyInputsListRow(
                        item: e,
                        controller: _controllers[e.symbol],
                        onFocusChanged: onFocusChanged,
                        onTextChanged: onTextChanged,
                        showCopyToClipboardButtons: settings.showCopyToClipboardButtons,
                        showFullCurrencyNameLabel: settings.showFullCurrencyNameLabel,
                      ),
                    ))
                .toList(),
          );
        });
  }
}
