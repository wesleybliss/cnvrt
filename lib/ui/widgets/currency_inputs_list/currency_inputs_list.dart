import 'package:cnvrt/domain/di/providers/currencies/currency_values_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/sorted_currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/ui/widgets/currency_inputs_list/currency_inputs_list_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/ui/widgets/currency_inputs_list/currency_inputs_list_vm.dart'; // Import your new ViewModel

class CurrenciesInputsList extends ConsumerWidget {
  // Since the data comes from providers, the constructor might not need
  // to take a list of currencies directly anymore, depending on your setup.
  // If you still need it for initial filtering or something, keep it.
  // final List<Currency> currencies;
  const CurrenciesInputsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(currencyInputsListViewModelProvider.notifier);
    final settingsAsyncValue = ref.watch(settingsNotifierProvider);
    final sortedCurrencies = ref.watch(sortedCurrenciesProvider);
    final controllers = ref.watch(currencyInputsListViewModelProvider);
    
    // Automatically call `updateControllers` when `currencyValuesProvider` changes
    ref.listen<Map<String, double>>(currencyValuesProvider, (_, next) {
      viewModel.updateControllers(next);
    });
    
    return settingsAsyncValue.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (settings) {
        return ReorderableListView(
          shrinkWrap: true,
          onReorder: viewModel.onReorderCurrency,
          children:
          sortedCurrencies
              .map(
                (e) => ListTile(
              key: ValueKey(e.symbol),
              leading: settings.showDragReorderHandles ? const Icon(Icons.drag_handle) : null,
              title: CurrencyInputsListRow(
                item: e,
                controller: controllers[e.symbol],
                onFocusChanged: viewModel.onFocusChanged,
                onTextChanged: viewModel.onTextChanged,
                useLargeInputs: settings.useLargeInputs,
                showCopyToClipboardButtons: settings.showCopyToClipboardButtons,
                showFullCurrencyNameLabel: settings.showFullCurrencyNameLabel,
                showCountryFlags: settings.showCountryFlags,
              ),
            ),
          )
              .toList(),
        );
      },
    );
  }
}
