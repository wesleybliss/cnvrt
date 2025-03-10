import 'package:cnvrt/domain/models/currency.dart';
import 'package:cnvrt/utils/conditionally_visible.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentExchangeRatesInfo extends StatelessWidget {
  final Currency? focusedCurrency;
  final String? focusedCurrencyInputSymbol;
  final List<Currency> selectedCurrencies;
  final String showCurrencyRate;

  const CurrentExchangeRatesInfo({
    super.key,
    required this.focusedCurrency,
    required this.focusedCurrencyInputSymbol,
    required this.selectedCurrencies,
    required this.showCurrencyRate,
  });

  @override
  Widget build(BuildContext context) {
    // @todo make this use the currently selected currency
    final nf = NumberFormat.currency(locale: 'en_US', symbol: '');

    if (showCurrencyRate == "all") {
      return Text(selectedCurrencies.map((e) => '${e.symbol}: ${nf.format(e.rate)}').join('\n'));
    } else {
      final currentExchangeRate =
          focusedCurrency == null ? '' : '\$1 = ${nf.format(focusedCurrency?.rate)} $focusedCurrencyInputSymbol';

      return ConditionallyVisible(
        isVisible: showCurrencyRate == "selected",
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "EXCHANGE RATE",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withAlpha(125)),
            ),
            Text(
              currentExchangeRate,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontFamily: 'monospace', color: Theme.of(context).colorScheme.surfaceTint),
            ),
          ],
        ),
      );
    }
  }
}
