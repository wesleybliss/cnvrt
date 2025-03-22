import 'package:cnvrt/utils/currency_locales.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class WholeNumberCurrencyFormatter extends TextInputFormatter {
  final String currencySymbol;

  WholeNumberCurrencyFormatter({required this.currencySymbol});

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

    // Format as whole number with currency symbol
    final formatter = NumberFormat.currency(
      locale: currencyLocales[currencySymbol] ?? 'en_US',
      symbol: '', // '\$',
      decimalDigits: 0, // Set to 0 for whole numbers
    );

    String formattedValue = formatter.format(int.parse(newText)).trim();

    return TextEditingValue(text: formattedValue, selection: TextSelection.collapsed(offset: formattedValue.length));
  }
}
