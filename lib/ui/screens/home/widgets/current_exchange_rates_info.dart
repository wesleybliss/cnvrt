import 'package:flutter/material.dart';
import 'package:cnvrt/domain/models/currency.dart';

class CurrentExchangeRatesInfo extends StatelessWidget {
  final Currency? focusedCurrency;
  final String? focusedCurrencyInputSymbol;
  final Map<String, double> currencyValues;
  final String showCurrencyRate;

  const CurrentExchangeRatesInfo({
    super.key,
    required this.focusedCurrency,
    required this.focusedCurrencyInputSymbol,
    required this.currencyValues,
    required this.showCurrencyRate,
  });

  @override
  Widget build(BuildContext context) {
    if (showCurrencyRate == "all") {
      return Text(
          currencyValues.entries.map((e) => '${e.key}: ${e.value}').join('\n'));
    } else if (showCurrencyRate == "selected") {
      final currentExchangeRate = focusedCurrency == null
          ? ''
          : 'Exchange Rate: \$1 = ${focusedCurrency?.rate} $focusedCurrencyInputSymbol';

      return Text(currentExchangeRate);
    } else {
      return Container();
    }
  }
}
