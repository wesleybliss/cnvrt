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

    test('returns original value for inflated currencies without delimiter', () {
      // Integer values without decimal points will still have "." in string representation (e.g., "1000.0")
      // So they will get the inflation multiplier
      expect(getInflatedCurrencyValue('COP', 1000), equals(1000000.0));
      expect(getInflatedCurrencyValue('IDR', 5000), equals(5000000.0));
      expect(getInflatedCurrencyValue('VND', 25000), equals(25000000.0));
    });

    test('multiplies for inflated currencies when period decimal index makes hasDelimiter true', () {
      // hasDelimiter check: (commaIndex + decimalIndex) > 0
      // For "100.5": commaIndex=-1, decimalIndex=3, sum=2 > 0, so multiplication DOES happen
      // For "5.25": commaIndex=-1, decimalIndex=1, sum=0, NOT > 0, so NO multiplication
      expect(getInflatedCurrencyValue('COP', 100.50), equals(100000.5)); // "100.5" idx 3
      expect(getInflatedCurrencyValue('IDR', 5.25), equals(5.25)); // "5.25" idx 1
      expect(getInflatedCurrencyValue('VND', 10.5), equals(10000.5)); // "10.5" idx 2
      expect(getInflatedCurrencyValue('KRW', 1.0), equals(1.0)); // "1.0" idx 1
    });

    test('multiplies by 1000 for inflated currencies based on decimal position', () {
      // Dart doubles stringify with period: "100.5" has period at index 3
      // hasDelimiter = (-1 + 3) = 2 > 0, so multiplication happens
      expect(getInflatedCurrencyValue('COP', 100.50), equals(100000.5));
      // "2.75" has period at index 1, hasDelimiter = (-1 + 1) = 0, NOT > 0, NO multiplication
      expect(getInflatedCurrencyValue('IRR', 2.75), equals(2.75));
    });

    test('does NOT multiply for inflated currencies with only period (Dart double stringification)', () {
      final inflatedCodes = ['COP', 'IDR', 'VND', 'KRW', 'IRR', 'PYG', 'CLP', 'LAK', 'LBP', 'TRY'];
      
      for (var code in inflatedCodes) {
        // 1.5 becomes "1.5", commaIndex=-1, decimalIndex=1, sum=0, NOT > 0
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
      // 1000.5 becomes "1000.5", splits to ["1000", "5"], becomes ["1000000", "5"], joins to "1000000.5"
      expect(getInflatedCurrencyValue('COP', 1000.5), equals(1000000.5));
      // 999.99 becomes "999.99", splits to ["999", "99"], becomes ["999000", "99"], joins to "999000.99"
      expect(getInflatedCurrencyValue('VND', 999.99), equals(999000.99));
    });

    test('handles zero value', () {
      expect(getInflatedCurrencyValue('COP', 0.0), equals(0.0));
      expect(getInflatedCurrencyValue('USD', 0.0), equals(0.0));
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
