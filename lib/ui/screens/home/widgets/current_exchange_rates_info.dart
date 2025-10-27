import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
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
    final Widget child;

    if (showCurrencyRate == "all") {
      child = Text(
        selectedCurrencies
            .map((e) => '${e.symbol}: ${nf.format(e.rate)}')
            .join('\n'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17,
          fontFamily: 'monospace',
          color: Theme.of(context).colorScheme.surfaceTint,
        ),
      );
    } else {
      final currentExchangeRate =
          focusedCurrency == null
              ? ''
              : '\$1 = ${nf.format(focusedCurrency?.rate)} $focusedCurrencyInputSymbol';

      child = Text(
        currentExchangeRate,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17,
          fontFamily: 'monospace',
          color: Theme.of(context).colorScheme.surfaceTint,
        ),
      );
    }

    return ConditionallyVisible(
      isVisible: showCurrencyRate == "selected" || showCurrencyRate == "all",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            focusedCurrency != null ? AppLocalizations.of(context)!.exchangeRate.toUpperCase() : "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(125),
            ),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
