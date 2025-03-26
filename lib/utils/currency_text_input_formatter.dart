import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyTextInputFormatter extends TextInputFormatter {
  final String currencyCode;
  final int decimalRange;

  CurrencyTextInputFormatter({required this.currencyCode, this.decimalRange = 2});

  static String formatCurrencyDisplay(String value, String currencyCode, {int decimalRange = 2}) {
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

    // Round the value to the specified decimal places
    final double roundedValue = double.parse(numericValue.toStringAsFixed(decimalRange));

    // Use intl package for proper formatting
    final NumberFormat numberFormat;

    switch (currencyCode) {
      case 'USD':
      case 'GBP':
      case 'AUD':
        numberFormat =
            NumberFormat.decimalPattern('en_US')
              ..minimumFractionDigits = decimalRange
              ..maximumFractionDigits = decimalRange;
        break;
      case 'EUR':
        numberFormat =
            NumberFormat.decimalPattern('de_DE')
              ..minimumFractionDigits = decimalRange
              ..maximumFractionDigits = decimalRange;
        break;
      case 'COP':
        numberFormat =
            NumberFormat.decimalPattern('es_CO')
              ..minimumFractionDigits = decimalRange
              ..maximumFractionDigits = decimalRange;
        break;
      case 'BRL':
        numberFormat =
            NumberFormat.decimalPattern('pt_BR')
              ..minimumFractionDigits = decimalRange
              ..maximumFractionDigits = decimalRange;
        break;
      default:
        numberFormat =
            NumberFormat.decimalPattern('en_US')
              ..minimumFractionDigits = decimalRange
              ..maximumFractionDigits = decimalRange;
    }

    return numberFormat.format(roundedValue);
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
    final RegExp regex = RegExp(r'^\d*([.,]\d*)?$');

    if (regex.hasMatch(cleanText)) {
      // Truncate to the specified number of decimal places
      if (cleanText.contains(decimalSeparator)) {
        final parts = cleanText.split(decimalSeparator);
        if (parts.length == 2) {
          parts[1] = parts[1].substring(0, min(decimalRange, parts[1].length));
          cleanText = parts.join(decimalSeparator);
        }
      }

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

      cleanText = _ensureTrailingDecimalPlace(cleanText, decimalSeparator);

      return TextEditingValue(text: cleanText, selection: TextSelection.collapsed(offset: cleanText.length));
    }

    return oldValue.copyWith(text: _ensureTrailingDecimalPlace(oldValue.text, decimalSeparator));
  }

  String _ensureTrailingDecimalPlace(String value, String decimalSeparator) {
    if (!value.contains(decimalSeparator)) return value;

    final trailing = value.split(decimalSeparator).last;

    return trailing.length < decimalRange ? '${value}0' : value;
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
