import 'package:cnvrt/domain/di/spot.dart';
import 'package:cnvrt/domain/io/i_settings.dart';
import 'package:cnvrt/domain/models/currency.dart';
import 'package:cnvrt/utils/logger.dart';

/// Converts the input value to the currency of the symbol, using USD as the base.
/// Returns a map of symbol to converted value.
Map<String, double> convertCurrencies(String symbol, double inputValue, List<Currency> currencies) {
  final log = Logger('convertCurrencies');
  log.d('DEBUG DEBUG: convertCurrencies: ${currencies.join(', ')}');
  // Find the currency that was changed
  final Currency changedCurrency = currencies.firstWhere((it) => it.symbol == symbol);

  // Convert the input value to USD
  final double valueInUSD = symbol == 'USD' ? inputValue : inputValue / changedCurrency.rate;

  // Create a map of symbol to converted value
  final Map<String, double> updatedValues = {};

  for (var currency in currencies) {
    final settings = spot<ISettings>();
    final int decimals = settings.roundingDecimals;
    final double convertedValue = valueInUSD * currency.rate;
    final double roundedValue = double.parse(convertedValue.toStringAsFixed(decimals));
    updatedValues[currency.symbol] = convertedValue;
  }

  return updatedValues;
}
