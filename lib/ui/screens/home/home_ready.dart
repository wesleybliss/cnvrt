import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/currency_values_provider.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/ui/widgets/currency_inputs_list/currency_inputs_list.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/current_exchange_rates_info.dart';

class HomeReady extends ConsumerWidget {
  const HomeReady({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = Logger('HomeReady');
    final settingsAsyncValue = ref.watch(settingsNotifierProvider);
    final state = ref.watch(currenciesProvider);
    final selectedCurrencies = ref.watch(selectedCurrenciesProvider);

    // @debug
    final focusedCurrencyInputSymbol = ref.watch(focusedCurrencyInputSymbolProvider);
    final focusedCurrency = selectedCurrencies.firstWhereOrNull((it) => it.symbol == focusedCurrencyInputSymbol);
    final Map<String, double> currencyValues = ref.watch(currencyValuesProvider);

    log.d('HomeReady: ${state.currencies.length} total');
    log.d('HomeReady: ${selectedCurrencies.length} selected');

    if (selectedCurrencies.isEmpty == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (state.error != null) Text(state.error!),
          const Center(
            child: Text('You don\'t have any currencies selected yet. \nAdd some by clicking the button below.'),
          ),
          const SizedBox(height: 24.0),
          TextButton(
            onPressed: () => Application.router.navigateTo(context, Routes.currencies),
            child: const Text('Manage Currencies'),
          ),
        ],
      );
    }

    return settingsAsyncValue.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (settings) {
        return Column(
          mainAxisAlignment:
              settings.inputsPosition == "top"
                  ? MainAxisAlignment.start
                  : settings.inputsPosition == "bottom"
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.center,
          children: [
            CurrenciesInputsList(currencies: selectedCurrencies),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: CurrentExchangeRatesInfo(
                focusedCurrency: focusedCurrency,
                focusedCurrencyInputSymbol: focusedCurrencyInputSymbol,
                selectedCurrencies: selectedCurrencies,
                showCurrencyRate: settings.showCurrencyRate,
              ),
            ),
            // const NumericKeyboardGrid(),
          ],
        );
      },
    );
  }
}
