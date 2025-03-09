import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyTextInputFormatter extends TextInputFormatter {
  final String currencyCode;

  CurrencyTextInputFormatter({required this.currencyCode});

  static String formatCurrencyDisplay(String value, String currencyCode) {
    if (value.isEmpty) return '';

    // Parse the value to double, handling different decimal separators
    double? numericValue;

    final formatter = CurrencyTextInputFormatter(currencyCode: currencyCode);
    final decimalSeparator = formatter.getDecimalSeparator(currencyCode);

    if (decimalSeparator == '.') {
      numericValue = double.tryParse(value);
    } else {
      // Convert from comma decimal separator to period for parsing
      numericValue = double.tryParse(value.replaceAll(',', '.'));
    }

    if (numericValue == null) return value;

    // Use intl package for proper formatting
    final NumberFormat numberFormat;

    switch (currencyCode) {
      case 'USD':
      case 'GBP':
      case 'AUD':
        numberFormat = NumberFormat.decimalPattern('en_US');
        break;
      case 'EUR':
        numberFormat = NumberFormat.decimalPattern('de_DE');
        break;
      case 'COP':
        numberFormat = NumberFormat.decimalPattern('es_CO');
        break;
      case 'BRL':
        numberFormat = NumberFormat.decimalPattern('pt_BR');
        break;
      default:
        numberFormat = NumberFormat.decimalPattern('en_US');
    }

    return numberFormat.format(numericValue);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue; // Allow empty input
    }

    // Determine the decimal separator based on currency
    final String decimalSeparator = getDecimalSeparator(currencyCode);
    final String groupSeparator = getGroupSeparator(currencyCode);

    // Remove any existing group separators from the input
    String cleanText = newValue.text.replaceAll(groupSeparator, '');

    // Regular expression to match valid decimal numbers with the appropriate separator
    final RegExp regex = RegExp('^\\d*\\$decimalSeparator?\\d*\$');

    if (regex.hasMatch(cleanText)) {
      // Format the number with group separators if needed
      if (cleanText.length > 3 && !cleanText.contains(decimalSeparator)) {
        // Add group separators for the integer part
        cleanText = _addGroupSeparators(cleanText, groupSeparator);
      } else if (cleanText.contains(decimalSeparator)) {
        // Split into integer and decimal parts
        final parts = cleanText.split(decimalSeparator);
        if (parts.length == 2 && parts[0].length > 3) {
          // Format the integer part with group separators
          parts[0] = _addGroupSeparators(parts[0], groupSeparator);
          cleanText = parts.join(decimalSeparator);
        }
      }

      return TextEditingValue(text: cleanText, selection: TextSelection.collapsed(offset: cleanText.length));
    }

    return oldValue;
  }

  String _addGroupSeparators(String value, String separator) {
    final result = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) {
        result.write(separator);
      }
      result.write(value[i]);
    }
    return result.toString();
  }

  String getDecimalSeparator(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
      case 'GBP':
      case 'AUD':
        return '.';
      case 'EUR':
      case 'COP':
      case 'BRL':
        return ',';
      default:
        return '.';
    }
  }

  String getGroupSeparator(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
      case 'GBP':
      case 'AUD':
        return ',';
      case 'EUR':
      case 'COP':
      case 'BRL':
        return '.';
      default:
        return ',';
    }
  }
}
