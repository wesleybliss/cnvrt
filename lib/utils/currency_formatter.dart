import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter extends TextInputFormatter {
  final String currencySymbol;
  final int decimalDigits;
  final bool allowDecimals;

  CurrencyFormatter({required this.currencySymbol, this.decimalDigits = 2, this.allowDecimals = true});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters (but keep decimal point if decimals are allowed)
    String newText;
    double value;
    
    if (allowDecimals) {
      // When decimals are allowed, keep the decimal point
      newText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');
      if (newText.isEmpty) {
        return newValue;
      }
      
      // Parse as decimal number directly
      value = double.tryParse(newText) ?? 0.0;
    } else {
      // When decimals are not allowed, remove everything except digits
      newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (newText.isEmpty) {
        return newValue;
      }
      
      // Treat input as whole units
      value = double.parse(newText);
    }

    // Format with appropriate decimal places
    final effectiveDecimalDigits = allowDecimals ? decimalDigits : 0;
    final formatter = NumberFormat.currency(
      locale: /*currencyLocales[currencySymbol] ??*/ 'en_US',
      symbol: '',
      decimalDigits: effectiveDecimalDigits,
    );

    String formattedValue = formatter.format(value).trim();

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
