import 'package:cnvrt/utils/currency_text_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getDecimalSeparator', () {
    test('returns period for USD', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'USD');
      expect(formatter.getDecimalSeparator('USD'), equals('.'));
    });

    test('returns period for GBP', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'GBP');
      expect(formatter.getDecimalSeparator('GBP'), equals('.'));
    });

    test('returns period for AUD', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'AUD');
      expect(formatter.getDecimalSeparator('AUD'), equals('.'));
    });

    test('returns comma for EUR', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'EUR');
      expect(formatter.getDecimalSeparator('EUR'), equals(','));
    });

    test('returns comma for COP', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'COP');
      expect(formatter.getDecimalSeparator('COP'), equals(','));
    });

    test('returns comma for BRL', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'BRL');
      expect(formatter.getDecimalSeparator('BRL'), equals(','));
    });

    test('returns period as default for unknown currency codes', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'XYZ');
      expect(formatter.getDecimalSeparator('XYZ'), equals('.'));
      expect(formatter.getDecimalSeparator('JPY'), equals('.'));
      expect(formatter.getDecimalSeparator('CAD'), equals('.'));
    });
  });

  group('getGroupSeparator', () {
    test('returns comma for USD', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'USD');
      expect(formatter.getGroupSeparator('USD'), equals(','));
    });

    test('returns comma for GBP', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'GBP');
      expect(formatter.getGroupSeparator('GBP'), equals(','));
    });

    test('returns comma for AUD', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'AUD');
      expect(formatter.getGroupSeparator('AUD'), equals(','));
    });

    test('returns period for EUR', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'EUR');
      expect(formatter.getGroupSeparator('EUR'), equals('.'));
    });

    test('returns period for COP', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'COP');
      expect(formatter.getGroupSeparator('COP'), equals('.'));
    });

    test('returns period for BRL', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'BRL');
      expect(formatter.getGroupSeparator('BRL'), equals('.'));
    });

    test('returns comma as default for unknown currency codes', () {
      final formatter = CurrencyTextInputFormatter(currencyCode: 'XYZ');
      expect(formatter.getGroupSeparator('XYZ'), equals(','));
      expect(formatter.getGroupSeparator('JPY'), equals(','));
      expect(formatter.getGroupSeparator('CAD'), equals(','));
    });
  });

  group('formatCurrencyDisplay', () {
    test('returns empty string for empty input', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('', 'USD'),
        equals(''),
      );
    });

    test('formats USD with period decimal separator', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100.50', 'USD'),
        equals('100.50'),
      );
    });

    test('formats EUR with comma decimal separator', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100.50', 'EUR'),
        equals('100,50'),
      );
    });

    test('formats GBP with period decimal separator', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('50.25', 'GBP'),
        equals('50.25'),
      );
    });

    test('formats AUD with period decimal separator', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('75.99', 'AUD'),
        equals('75.99'),
      );
    });

    test('formats COP with comma decimal separator', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('1000.50', 'COP'),
        equals('1.000,50'),
      );
    });

    test('formats BRL with comma decimal separator', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('250.75', 'BRL'),
        equals('250,75'),
      );
    });

    test('rounds to 2 decimal places by default', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100.123456', 'USD', decimalRange: 2),
        equals('100.12'),
      );
    });

    test('rounds to 3 decimal places when specified', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100.123456', 'USD', decimalRange: 3),
        equals('100.123'),
      );
    });

    test('rounds to 4 decimal places when specified', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100.123456', 'USD', decimalRange: 4),
        equals('100.1235'),
      );
    });

    test('formats very large numbers with thousands separators', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('1000000.50', 'USD'),
        equals('1,000,000.50'),
      );
    });

    test('formats very large numbers with EUR formatting', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('1000000.50', 'EUR'),
        equals('1.000.000,50'),
      );
    });

    test('handles very small decimal values', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('0.01', 'USD', decimalRange: 2),
        equals('0.01'),
      );
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('0.001', 'USD', decimalRange: 3),
        equals('0.001'),
      );
    });

    test('handles zero value', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('0', 'USD'),
        equals('0.00'),
      );
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('0.00', 'EUR'),
        equals('0,00'),
      );
    });

    test('handles whole numbers without decimals', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100', 'USD'),
        equals('100.00'),
      );
    });

    test('adds trailing zeros to match decimal range', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100.5', 'USD', decimalRange: 2),
        equals('100.50'),
      );
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100.5', 'EUR', decimalRange: 3),
        equals('100,500'),
      );
    });

    test('handles input with comma as decimal separator for EUR', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100,50', 'EUR'),
        equals('100,50'),
      );
    });

    test('returns original value for invalid numeric input', () {
      final result = CurrencyTextInputFormatter.formatCurrencyDisplay('abc', 'USD');
      // Invalid input should return the original or empty
      expect(result, equals('abc'));
    });

    test('handles negative values', () {
      // Note: This depends on implementation - adjust if needed
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('-100.50', 'USD'),
        equals('-100.50'),
      );
    });

    test('formats different currencies consistently', () {
      final testCases = {
        'USD': '1,234.56',
        'GBP': '1,234.56',
        'AUD': '1,234.56',
        'EUR': '1.234,56',
        'COP': '1.234,56',
        'BRL': '1.234,56',
      };

      testCases.forEach((currency, expected) {
        final result = CurrencyTextInputFormatter.formatCurrencyDisplay(
          '1234.56',
          currency,
        );
        expect(result, equals(expected), reason: 'Failed for $currency');
      });
    });

    test('handles maximum precision', () {
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('123.456789', 'USD', decimalRange: 6),
        equals('123.456789'),
      );
    });

    test('rounds correctly using Dart rounding rules', () {
      // Dart uses "round half away from zero" for toStringAsFixed
      // 100.125 rounds to 100.13 (away from zero)
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100.125', 'USD', decimalRange: 2),
        equals('100.13'),
      );
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100.124', 'USD', decimalRange: 2),
        equals('100.12'),
      );
      expect(
        CurrencyTextInputFormatter.formatCurrencyDisplay('100.126', 'USD', decimalRange: 2),
        equals('100.13'),
      );
    });
  });
}
