import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/services.dart';
import 'package:sealed_currencies/sealed_currencies.dart';
import 'package:cnvrt/utils/logger.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final log = Logger('CurrencyInputFormatter');
  final String symbol;
  late final Currency _currency;
  
  CurrencyInputFormatter(this.symbol) {
    try {
      _currency = FiatCurrency.fromCode(symbol.toUpperCase());
    } catch (e) {
      // Fallback to USD if currency not found
      log.w('CurrencyInputFormatter: currency not found: $symbol');
      _currency = FiatCurrency.fromCode('USD');
    }
    
    log.d('CurrencyInputFormatter: ${symbol} thousandSeparator: ${_currency.thousandsSeparator}, decimalSeparator: ${_currency.decimalMark}');
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any non-digit characters
    final String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Convert the digits to a double
    final double value = double.tryParse(digitsOnly) ?? 0.0;
  
    // Format the value as currency
    final CurrencyFormat settings = CurrencyFormat(
      code: symbol,
      symbol: '',
      symbolSide: SymbolSide.none,
      thousandSeparator: _currency.thousandsSeparator,
      decimalSeparator: _currency.decimalMark,
      symbolSeparator: '',
    );
    final String formattedValue = CurrencyFormatter.format(value, settings);

    log.d('CurrencyInputFormatter: $symbol / formattedValue: $value -> $formattedValue');
    
    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
