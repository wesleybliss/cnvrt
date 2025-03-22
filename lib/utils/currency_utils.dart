import 'package:cnvrt/domain/di/spot.dart';
import 'package:cnvrt/domain/io/i_settings.dart';
import 'package:cnvrt/domain/models/currency.dart';
import 'package:cnvrt/utils/logger.dart';

List<String> inflatedCurrencies = ["COP", "IDR", "VND", "KRW", "IRR", "PYG", "CLP", "LAK", "LBP", "TRY"];

double getInflatedCurrencyValue(String symbol, double value) {
  final log = Logger('convertCurrencies');

  String result = "$value";
  final commaIndex = result.indexOf(",");
  final decimalIndex = result.indexOf(".");
  final delimiter = commaIndex > decimalIndex ? "," : ".";
  final hasDelimiter = (commaIndex + decimalIndex) > 0;

  if (inflatedCurrencies.contains(symbol) && hasDelimiter) {
    final parts = result.split(delimiter);

    if (parts.length == 2) {
      parts[0] = "${parts[0]}000";
    } else if (parts.length > 2) {
      parts[parts.length - 2] = "${parts[parts.length - 2]}000";
    }

    result = parts.join(delimiter);
  }

  return double.parse(result);
}

/// Converts the input value to the currency of the symbol, using USD as the base.
/// Returns a map of symbol to converted value.
Map<String, double> convertCurrencies(String symbol, double inputValue, List<Currency> currencies) {
  final log = Logger('convertCurrencies');

  final settings = spot<ISettings>();

  // Find the currency that was changed
  final Currency changedCurrency = currencies.firstWhere((it) => it.symbol == symbol);

  // If the currency is very inflated, automatically adjust for easier UX
  final sourceValue =
      settings.accountForInflation ? getInflatedCurrencyValue(changedCurrency.symbol, inputValue) : inputValue;

  log.d('convertCurrencies: $inputValue -> $sourceValue -> ${currencies.join(', ')}');

  // Convert the input value to USD
  final double valueInUSD = symbol == 'USD' ? sourceValue : sourceValue / changedCurrency.rate;

  // Create a map of symbol to converted value
  final Map<String, double> updatedValues = {};

  for (var currency in currencies) {
    final int decimals = settings.roundingDecimals;
    final double convertedValue = valueInUSD * currency.rate;
    final double roundedValue = double.parse(convertedValue.toStringAsFixed(decimals));

    updatedValues[currency.symbol] = roundedValue;
  }

  return updatedValues;
}

String removeAllButLastDecimal(String text) {
  // Define possible decimal separators
  const separators = {'.', ','};

  // Find the last occurrence of any decimal separator
  int lastDecimalIndex = -1;
  for (int i = text.length - 1; i >= 0; i--) {
    if (separators.contains(text[i])) {
      lastDecimalIndex = i;
      break;
    }
  }

  // If no decimal separator is found, return the original string
  if (lastDecimalIndex == -1) {
    return text;
  }

  // Build a new string, keeping only the last decimal separator
  String result = '';
  for (int i = 0; i < text.length; i++) {
    if (separators.contains(text[i])) {
      if (i == lastDecimalIndex) {
        result += text[i]; // Keep the last decimal separator
      } else {
        continue; // Skip other decimal separators
      }
    } else {
      result += text[i]; // Add non-separator characters
    }
  }

  return result;
}
