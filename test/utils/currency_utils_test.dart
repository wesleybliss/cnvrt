import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/io/settings.dart';
import 'package:cnvrt/utils/currency_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/spot_test_helper.dart';

void main() {
  group('removeAllButLastDecimal', () {
    test('returns original string when no decimal separators present', () {
      expect(removeAllButLastDecimal('12345'), equals('12345'));
      expect(removeAllButLastDecimal('0'), equals('0'));
      expect(removeAllButLastDecimal('999999'), equals('999999'));
    });

    test('returns original string when single period present', () {
      expect(removeAllButLastDecimal('123.45'), equals('123.45'));
      expect(removeAllButLastDecimal('0.99'), equals('0.99'));
      expect(removeAllButLastDecimal('.5'), equals('.5'));
      expect(removeAllButLastDecimal('100.'), equals('100.'));
    });

    test('returns original string when single comma present', () {
      expect(removeAllButLastDecimal('123,45'), equals('123,45'));
      expect(removeAllButLastDecimal('0,99'), equals('0,99'));
      expect(removeAllButLastDecimal(',5'), equals(',5'));
      expect(removeAllButLastDecimal('100,'), equals('100,'));
    });

    test('keeps only last period when multiple periods present', () {
      expect(removeAllButLastDecimal('1.2.3'), equals('12.3'));
      expect(removeAllButLastDecimal('1.2.3.4'), equals('123.4'));
      expect(removeAllButLastDecimal('100.200.50'), equals('100200.50'));
    });

    test('keeps only last comma when multiple commas present', () {
      expect(removeAllButLastDecimal('1,2,3'), equals('12,3'));
      expect(removeAllButLastDecimal('1,2,3,4'), equals('123,4'));
      expect(removeAllButLastDecimal('100,200,50'), equals('100200,50'));
    });

    test('keeps only last decimal separator when mixed separators present', () {
      expect(removeAllButLastDecimal('1,000.50'), equals('1000.50'));
      expect(removeAllButLastDecimal('1.000,50'), equals('1000,50'));
      expect(removeAllButLastDecimal('1,2.3,4'), equals('123,4'));
      expect(removeAllButLastDecimal('1.2,3.4'), equals('123.4'));
    });

    test('handles empty string', () {
      expect(removeAllButLastDecimal(''), equals(''));
    });

    test('handles decimal at start', () {
      expect(removeAllButLastDecimal('.5'), equals('.5'));
      expect(removeAllButLastDecimal(',5'), equals(',5'));
    });

    test('handles decimal at end', () {
      expect(removeAllButLastDecimal('100.'), equals('100.'));
      expect(removeAllButLastDecimal('100,'), equals('100,'));
    });
  });

  group('getInflatedCurrencyValue', () {
    test('returns original value for non-inflated currencies', () {
      expect(getInflatedCurrencyValue('USD', 100.50), equals(100.50));
      expect(getInflatedCurrencyValue('EUR', 50.25), equals(50.25));
      expect(getInflatedCurrencyValue('GBP', 75.99), equals(75.99));
      expect(getInflatedCurrencyValue('JPY', 1000.0), equals(1000.0));
    });

    test('multiplies whole numbers for inflated currencies', () {
      // Whole numbers (integers) should get multiplied by 1000
      expect(getInflatedCurrencyValue('COP', 1000), equals(1000000.0));
      expect(getInflatedCurrencyValue('IDR', 5000), equals(5000000.0));
      expect(getInflatedCurrencyValue('VND', 25000), equals(25000000.0));
      expect(getInflatedCurrencyValue('COP', 4), equals(4000.0));
    });

    test('does NOT multiply decimal values for inflated currencies', () {
      // Decimal values should NOT be multiplied - allows precise entry
      expect(getInflatedCurrencyValue('COP', 100.50), equals(100.50));
      expect(getInflatedCurrencyValue('IDR', 5.25), equals(5.25));
      expect(getInflatedCurrencyValue('VND', 10.5), equals(10.5));
      expect(getInflatedCurrencyValue('KRW', 1.5), equals(1.5));
    });

    test('handles edge case: value that looks like whole number (e.g., 1.0)', () {
      // 1.0 equals its floor (1), so it's treated as a whole number and multiplied
      expect(getInflatedCurrencyValue('COP', 1.0), equals(1000.0));
      // But 1.5 is not equal to its floor, so it's not multiplied
      expect(getInflatedCurrencyValue('IRR', 2.75), equals(2.75));
    });

    test('does NOT multiply decimal values for any inflated currency', () {
      final inflatedCodes = ['COP', 'IDR', 'VND', 'KRW', 'IRR', 'PYG', 'CLP', 'LAK', 'LBP', 'TRY'];
      
      for (var code in inflatedCodes) {
        // Decimal values are not multiplied
        expect(getInflatedCurrencyValue(code, 1.5), equals(1.5));
      }
    });

    test('handles very small values', () {
      // 0.01 becomes "0.01", splits to ["0", "01"], becomes ["0000", "01"], joins to "0000.01" = 0.01
      expect(getInflatedCurrencyValue('COP', 0.01), equals(0.01));
      // 0.001 becomes "0.001", splits to ["0", "001"], becomes ["0000", "001"], joins to "0000.001" = 0.001
      expect(getInflatedCurrencyValue('IDR', 0.001), equals(0.001));
    });

    test('handles very large values', () {
      // Decimal values are not multiplied, even if large
      expect(getInflatedCurrencyValue('COP', 1000.5), equals(1000.5));
      expect(getInflatedCurrencyValue('VND', 999.99), equals(999.99));
    });

    test('handles zero value', () {
      expect(getInflatedCurrencyValue('COP', 0.0), equals(0.0));
      expect(getInflatedCurrencyValue('USD', 0.0), equals(0.0));
    });
    
    test('edge case: COP to USD with inflation adjustment', () {
      // 4 COP should become 4000 COP, which is roughly 1 USD
      expect(getInflatedCurrencyValue('COP', 4), equals(4000.0));
    });
  });

  group('convertCurrencies', () {
    setUp(() {
      SpotTestHelper.setupTestDependencies();
    });

    tearDown(() {
      SpotTestHelper.resetDI();
    });

    test('converts from USD to other currencies', () {
      final currencies = [
        const Currency(id: 1, symbol: 'USD', name: 'US Dollar', rate: 1.0, selected: true, order: 0),
        const Currency(id: 2, symbol: 'EUR', name: 'Euro', rate: 0.85, selected: true, order: 1),
        const Currency(id: 3, symbol: 'GBP', name: 'British Pound', rate: 0.73, selected: true, order: 2),
      ];

      final result = convertCurrencies('USD', 100.0, currencies);

      expect(result['USD'], equals(100.0));
      expect(result['EUR'], equals(85.0));
      expect(result['GBP'], equals(73.0));
    });

    test('converts from EUR to USD and other currencies', () {
      final currencies = [
        const Currency(id: 1, symbol: 'USD', name: 'US Dollar', rate: 1.0, selected: true, order: 0),
        const Currency(id: 2, symbol: 'EUR', name: 'Euro', rate: 0.85, selected: true, order: 1),
        const Currency(id: 3, symbol: 'GBP', name: 'British Pound', rate: 0.73, selected: true, order: 2),
      ];

      final result = convertCurrencies('EUR', 85.0, currencies);

      expect(result['USD'], equals(100.0));
      expect(result['EUR'], equals(85.0));
      expect(result['GBP'], equals(73.0));
    });

    test('converts between non-USD currencies via USD', () {
      final currencies = [
        const Currency(id: 1, symbol: 'EUR', name: 'Euro', rate: 0.85, selected: true, order: 0),
        const Currency(id: 2, symbol: 'GBP', name: 'British Pound', rate: 0.73, selected: true, order: 1),
        const Currency(id: 3, symbol: 'JPY', name: 'Japanese Yen', rate: 110.0, selected: true, order: 2),
      ];

      final result = convertCurrencies('EUR', 85.0, currencies);

      expect(result['EUR'], equals(85.0));
      expect(result['GBP'], equals(73.0));
      expect(result['JPY'], equals(11000.0));
    });
    
    test('converts between highly inflated currency and USD', () {
      const copPerUsd = 4115.61;
      final currencies = [
        const Currency(id: 1, symbol: 'COP', name: 'Colombian Peso', rate: copPerUsd, selected: true, order: 0),
        const Currency(id: 2, symbol: 'USD', name: 'US Dollar', rate: 1.0, selected: true, order: 1),
      ];
      
      final result = convertCurrencies('COP', copPerUsd, currencies);
      expect(result['COP'], equals(copPerUsd));
      expect(result['USD'], equals(1.0));
    });
    
    test('fixes bug: entering low value like 4 in COP shows proper USD value', () {
      // This is the exact bug scenario: entering "4" in COP should show ~$1 USD
      // With accountForInflation enabled, 4 COP becomes 4000 COP
      SpotTestHelper.setupTestDependencies(
        settings: Settings(
          roundingDecimals: 2,
          accountForInflation: true,
        ),
      );
      
      const copPerUsd = 4115.61;
      final currencies = [
        const Currency(id: 1, symbol: 'COP', name: 'Colombian Peso', rate: copPerUsd, selected: true, order: 0),
        const Currency(id: 2, symbol: 'USD', name: 'US Dollar', rate: 1.0, selected: true, order: 1),
      ];
      
      // User types "4" in COP field
      final result = convertCurrencies('COP', 4, currencies);
      
      // 4 gets inflated to 4000 COP
      // 4000 COP / 4115.61 ≈ 0.97 USD
      expect(result['COP'], equals(4000.0));
      expect(result['USD'], equals(0.97)); // Rounded to 2 decimals
    });

    test('respects rounding decimals setting', () {
      SpotTestHelper.setupTestDependencies(
        settings: Settings(roundingDecimals: 4),
      );

      final currencies = [
        const Currency(id: 1, symbol: 'USD', name: 'US Dollar', rate: 1.0, selected: true, order: 0),
        const Currency(id: 2, symbol: 'EUR', name: 'Euro', rate: 0.846, selected: true, order: 1),
      ];

      final result = convertCurrencies('USD', 100.0, currencies);

      expect(result['EUR'], equals(84.6));
    });

    test('inflation adjustment enabled but does not trigger with simple decimal', () {
      SpotTestHelper.setupTestDependencies(
        settings: Settings(
          roundingDecimals: 2,
          accountForInflation: true,
        ),
      );

      final currencies = [
        const Currency(id: 1, symbol: 'USD', name: 'US Dollar', rate: 1.0, selected: true, order: 0),
        const Currency(id: 2, symbol: 'COP', name: 'Colombian Peso', rate: 4000.0, selected: true, order: 1),
      ];

      // Input 1.5 COP: "1.5" has commaIndex=-1, decimalIndex=1, sum=0 (NOT > 0), so no inflation multiplier
      final result = convertCurrencies('COP', 1.5, currencies);

      // 1.5 COP / 4000 = 0.000375 USD
      expect(result['USD'], equals(0.0)); // Rounded to 2 decimals
      expect(result['COP'], equals(1.5));
    });

    test('does not adjust inflation when disabled', () {
      SpotTestHelper.setupTestDependencies(
        settings: Settings(
          roundingDecimals: 2,
          accountForInflation: false,
        ),
      );

      final currencies = [
        const Currency(id: 1, symbol: 'USD', name: 'US Dollar', rate: 1.0, selected: true, order: 0),
        const Currency(id: 2, symbol: 'COP', name: 'Colombian Peso', rate: 4000.0, selected: true, order: 1),
      ];

      // Input 1.5 COP without inflation should stay as 1.5
      final result = convertCurrencies('COP', 1.5, currencies);

      // 1.5 COP / 4000 = 0.000375 USD
      expect(result['USD'], equals(0.0)); // Rounded to 2 decimals
      expect(result['COP'], equals(1.5));
    });

    test('handles zero input value', () {
      final currencies = [
        const Currency(id: 1, symbol: 'USD', name: 'US Dollar', rate: 1.0, selected: true, order: 0),
        const Currency(id: 2, symbol: 'EUR', name: 'Euro', rate: 0.85, selected: true, order: 1),
      ];

      final result = convertCurrencies('USD', 0.0, currencies);

      expect(result['USD'], equals(0.0));
      expect(result['EUR'], equals(0.0));
    });

    test('handles very large values', () {
      final currencies = [
        const Currency(id: 1, symbol: 'USD', name: 'US Dollar', rate: 1.0, selected: true, order: 0),
        const Currency(id: 2, symbol: 'EUR', name: 'Euro', rate: 0.85, selected: true, order: 1),
      ];

      final result = convertCurrencies('USD', 1000000.0, currencies);

      expect(result['USD'], equals(1000000.0));
      expect(result['EUR'], equals(850000.0));
    });

    test('returns map with all currency symbols as keys', () {
      final currencies = [
        const Currency(id: 1, symbol: 'USD', name: 'US Dollar', rate: 1.0, selected: true, order: 0),
        const Currency(id: 2, symbol: 'EUR', name: 'Euro', rate: 0.85, selected: true, order: 1),
        const Currency(id: 3, symbol: 'GBP', name: 'British Pound', rate: 0.73, selected: true, order: 2),
        const Currency(id: 4, symbol: 'JPY', name: 'Japanese Yen', rate: 110.0, selected: true, order: 3),
      ];

      final result = convertCurrencies('USD', 100.0, currencies);

      expect(result.keys, containsAll(['USD', 'EUR', 'GBP', 'JPY']));
      expect(result.keys.length, equals(4));
    });
  });
}
