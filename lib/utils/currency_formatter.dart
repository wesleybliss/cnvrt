import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter extends TextInputFormatter {
  final String currencySymbol;
  final int decimalDigits;

  CurrencyFormatter({required this.currencySymbol, this.decimalDigits = 2});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (newText.isEmpty) {
      return newValue;
    }

    // Convert to decimal value
    double value = double.parse(newText) / pow(10, decimalDigits);

    // Format with appropriate decimal places
    final formatter = NumberFormat.currency(
      locale: /*currencyLocales[currencySymbol] ??*/ 'en_US',
      symbol: '',
      decimalDigits: decimalDigits,
    );

    String formattedValue = formatter.format(value).trim();

    return TextEditingValue(text: formattedValue, selection: TextSelection.collapsed(offset: formattedValue.length));
  }
}
