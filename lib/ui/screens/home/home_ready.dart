import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:cnvrt/ui/widgets/currency_inputs_list/currency_inputs_list.dart';
import 'package:cnvrt/ui/widgets/currency_inputs_list/currency_inputs_list_vm.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/current_exchange_rates_info.dart';

class HomeReady extends ConsumerStatefulWidget {
  const HomeReady({super.key});

  @override
  ConsumerState<HomeReady> createState() => _HomeReadyState();
}

class _HomeReadyState extends ConsumerState<HomeReady> {
  bool _hasAutoFocused = false;

  @override
  Widget build(BuildContext context) {
    final log = Logger('HomeReady');
    final settingsAsyncValue = ref.watch(settingsNotifierProvider);
    final state = ref.watch(currenciesProvider);
    final selectedCurrencies = ref.watch(selectedCurrenciesProvider);

    // @debug
    final focusedCurrencyInputSymbol = ref.watch(
      focusedCurrencyInputSymbolProvider,
    );
    final focusedCurrency = selectedCurrencies.firstWhereOrNull(
      (it) => it.symbol == focusedCurrencyInputSymbol,
    );

    log.d('HomeReady: ${state.currencies.length} total');
    log.d('HomeReady: ${selectedCurrencies.length} selected');

    // Auto-focus the first currency input when the screen loads
    if (!_hasAutoFocused &&
        selectedCurrencies.isNotEmpty &&
        focusedCurrencyInputSymbol == null) {
      _hasAutoFocused = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(currencyInputsListViewModelProvider.notifier)
            .requestFocusOnFirst();
      });
    }

    if (selectedCurrencies.isEmpty == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (state.error != null) Text(state.error!.toString()),
          Center(
            child: Text(AppLocalizations.of(context)!.noSelectedCurrencies),
          ),
          const SizedBox(height: 24.0),
          TextButton(
            onPressed:
                () => Application.router.navigateTo(context, Routes.currencies),
            child: Text(AppLocalizations.of(context)!.manageCurrencies),
          ),
        ],
      );
    }

    return settingsAsyncValue.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('${AppLocalizations.of(context)!.error}: $error'),
      data: (settings) {
        return Column(
          mainAxisAlignment:
              settings.inputsPosition == "top"
                  ? MainAxisAlignment.start
                  : settings.inputsPosition == "bottom"
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.center,
          children: [
            CurrenciesInputsList(/*currencies: selectedCurrencies*/),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
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
