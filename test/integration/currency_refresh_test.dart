import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/currencies/currency_values_provider.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/io/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Integration test reproducing the bug where entering a value in an inflated
// currency (COP) and then refreshing currencies from the API causes the
// converted USD value to be inflated a second time (e.g. 402 -> 402,047).
//
// We drive the real Riverpod providers (CurrencyValuesNotifier +
// recomputeWithLatestRates) to ensure the stored, already-inflated value is
// not re-inflated on refresh.
void main() {
  group('COP/USD refresh integration', () {
    late ProviderContainer container;

    // COP rate per 1 USD. 1234 COP -> 1,234,000 (inflated) / 3070 ≈ 402 USD.
    const copRate = 3070.0;

    final testCurrencies = [
      const Currency(
        id: 1,
        symbol: 'COP',
        name: 'Colombian Peso',
        rate: copRate,
        selected: true,
        order: 0,
      ),
      const Currency(
        id: 2,
        symbol: 'USD',
        name: 'US Dollar',
        rate: 1.0,
        selected: true,
        order: 1,
      ),
    ];

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      container = ProviderContainer(
        overrides: [
          settingsNotifierProvider.overrideWith(
            () => TestSettingsNotifier(
              Settings(
                roundingDecimals: 2,
                accountForInflation: true,
              ),
            ),
          ),
          selectedCurrenciesProvider.overrideWithValue(testCurrencies),
        ],
      );

      // Simulate the user focusing the COP input field.
      container
          .read(focusedCurrencyInputSymbolProvider.notifier)
          .setSymbol('COP');
    });

    tearDown(() => container.dispose());

    test(
      'USD value is unchanged after a currency refresh (no double inflation)',
      () async {
        // Ensure settings are loaded before conversion (the notifier guards on it).
        await container.read(settingsNotifierProvider.future);

        final notifier = container.read(currencyValuesProvider.notifier);

        // User types "1234" in the COP field.
        notifier.setValue('COP', '1234');

        final usdBefore = container.read(currencyValuesProvider)['USD'];
        final copBefore = container.read(currencyValuesProvider)['COP'];

        expect(usdBefore, isNotNull);
        // Sanity: this should be a small value (~402), NOT the buggy ~402,047.
        expect(usdBefore, lessThan(1000));
        expect(usdBefore, greaterThan(100));

        // Simulate a currency refresh (Force Refresh / background recompute).
        notifier.recomputeWithLatestRates();

        final usdAfter = container.read(currencyValuesProvider)['USD'];
        final copAfter = container.read(currencyValuesProvider)['COP'];

        // The key assertion: the value must not change after refresh.
        expect(usdAfter, equals(usdBefore));
        expect(copAfter, equals(copBefore));
      },
    );

    test(
      'USD value is unchanged after multiple refreshes',
      () async {
        await container.read(settingsNotifierProvider.future);

        final notifier = container.read(currencyValuesProvider.notifier);

        notifier.setValue('COP', '1234');

        final usdBefore = container.read(currencyValuesProvider)['USD'];
        expect(usdBefore, isNotNull);

        // Repeated refreshes must never drift the value.
        for (var i = 0; i < 5; i++) {
          notifier.recomputeWithLatestRates();
        }

        final usdAfter = container.read(currencyValuesProvider)['USD'];
        expect(usdAfter, equals(usdBefore));
      },
    );
  });
}

class TestSettingsNotifier extends SettingsNotifier {
  final Settings _settings;

  TestSettingsNotifier(this._settings);

  @override
  Future<Settings> build() async => _settings;
}
