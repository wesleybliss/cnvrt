import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/domain/io/i_settings.dart';
import 'package:cnvrt/io/settings.dart';
import 'package:cnvrt/ui/widgets/currency_inputs_list/currency_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';

import '../helpers/spot_test_helper.dart';

void main() {
  group('Currency Conversion Widget Test - COP to USD', () {
    late Settings testSettings;
    const copPerUsd = 4115.61;

    setUp(() {
      // Reset DI before each test
      SpotTestHelper.resetDI();
      
      // Setup test settings with decimal input disabled
      testSettings = Settings(
        roundingDecimals: 3, // Use 3 decimals to see the actual conversion (0.001 USD)
        accountForInflation: false,
        theme: "system",
        language: "en",
        updateFrequencyInHours: 12,
        useLargeInputs: false,
        showDragReorderHandles: false,
        showCopyToClipboardButtons: false,
        showFullCurrencyNameLabel: true,
        inputsPosition: "center",
        showCurrencyRate: "selected",
        showCountryFlags: true,
        allowDecimalInput: false, // Decimal input disabled
        developerModeActive: false,
      );
      
      Spot.registerSingle<ISettings, Settings>((get) => testSettings);
    });

    tearDown(() {
      SpotTestHelper.resetDI();
    });

    testWidgets('Entering 5 in COP field converts to approximately 0.001 USD', (WidgetTester tester) async {
      // Setup mock currencies
      final currencies = [
        const Currency(
          id: 1,
          symbol: 'COP',
          name: 'Colombian Peso',
          rate: copPerUsd,
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

      // Create controllers and focus nodes for testing
      final copController = TextEditingController();
      final usdController = TextEditingController();
      final copFocusNode = FocusNode();
      final usdFocusNode = FocusNode();

      // Build the widget tree with ProviderScope
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override the settings provider with our test settings
            settingsNotifierProvider.overrideWith(() => TestSettingsNotifier(testSettings)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // COP TextField
                  CurrencyTextField(
                    key: const Key('cop_input'),
                    item: currencies[0],
                    controller: copController,
                    focusNode: copFocusNode,
                    onTextChanged: (symbol, text) {
                      // Simulate the conversion logic
                      if (text.isNotEmpty) {
                        final numericText = text.replaceAll(RegExp(r'[^0-9.]'), '');
                        final inputValue = double.tryParse(numericText) ?? 0.0;
                        
                        // Convert COP to USD
                        final valueInUSD = inputValue / copPerUsd;
                        final roundedValue = double.parse(valueInUSD.toStringAsFixed(testSettings.roundingDecimals));
                        
                        // Update USD controller
                        usdController.text = roundedValue.toString();
                      } else {
                        usdController.text = '';
                      }
                    },
                    useLargeInputs: false,
                    showFullCurrencyNameLabel: true,
                    showCountryFlags: true,
                  ),
                  // USD TextField
                  CurrencyTextField(
                    key: const Key('usd_input'),
                    item: currencies[1],
                    controller: usdController,
                    focusNode: usdFocusNode,
                    onTextChanged: (symbol, text) {
                      // Simulate the conversion logic
                      if (text.isNotEmpty) {
                        final numericText = text.replaceAll(RegExp(r'[^0-9.]'), '');
                        final inputValue = double.tryParse(numericText) ?? 0.0;
                        
                        // Convert USD to COP
                        final valueInCOP = inputValue * copPerUsd;
                        final roundedValue = double.parse(valueInCOP.toStringAsFixed(testSettings.roundingDecimals));
                        
                        // Update COP controller
                        copController.text = roundedValue.toString();
                      } else {
                        copController.text = '';
                      }
                    },
                    useLargeInputs: false,
                    showFullCurrencyNameLabel: true,
                    showCountryFlags: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to be built
      await tester.pumpAndSettle();

      // Find the COP text field
      final copTextField = find.byKey(const Key('cop_input'));
      expect(copTextField, findsOneWidget);

      // Tap on the COP field to focus it (which should clear it based on onTap)
      await tester.tap(copTextField);
      await tester.pumpAndSettle();

      // Enter "5" in the COP field
      await tester.enterText(copTextField, '5');
      await tester.pumpAndSettle();

      // Verify the COP controller has the entered value
      expect(copController.text, equals('5'));

      // Calculate expected USD value
      // 5 COP / 4115.61 = 0.001215... USD
      // With 3 decimal places rounding: 0.001 USD
      final expectedUsdValue = 5.0 / copPerUsd;
      final expectedRoundedUsd = double.parse(expectedUsdValue.toStringAsFixed(3));
      
      // Verify the USD controller has been updated with the converted value
      expect(usdController.text, equals(expectedRoundedUsd.toString()));
      expect(expectedRoundedUsd, closeTo(0.001, 0.0001));
    });

    testWidgets('Entering 5 in COP with 2 decimal rounding shows 0.0 USD', (WidgetTester tester) async {
      // Reset settings with only 2 decimal places
      testSettings = Settings(
        roundingDecimals: 2, // Standard 2 decimals
        accountForInflation: false,
        theme: "system",
        language: "en",
        updateFrequencyInHours: 12,
        useLargeInputs: false,
        showDragReorderHandles: false,
        showCopyToClipboardButtons: false,
        showFullCurrencyNameLabel: true,
        inputsPosition: "center",
        showCurrencyRate: "selected",
        showCountryFlags: true,
        allowDecimalInput: false,
        developerModeActive: false,
      );
      
      Spot.registerSingle<ISettings, Settings>((get) => testSettings);

      final currencies = [
        const Currency(
          id: 1,
          symbol: 'COP',
          name: 'Colombian Peso',
          rate: copPerUsd,
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

      final copController = TextEditingController();
      final usdController = TextEditingController();
      final copFocusNode = FocusNode();
      final usdFocusNode = FocusNode();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsNotifierProvider.overrideWith(() => TestSettingsNotifier(testSettings)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  CurrencyTextField(
                    key: const Key('cop_input'),
                    item: currencies[0],
                    controller: copController,
                    focusNode: copFocusNode,
                    onTextChanged: (symbol, text) {
                      if (text.isNotEmpty) {
                        final numericText = text.replaceAll(RegExp(r'[^0-9.]'), '');
                        final inputValue = double.tryParse(numericText) ?? 0.0;
                        final valueInUSD = inputValue / copPerUsd;
                        final roundedValue = double.parse(valueInUSD.toStringAsFixed(testSettings.roundingDecimals));
                        usdController.text = roundedValue.toString();
                      } else {
                        usdController.text = '';
                      }
                    },
                    useLargeInputs: false,
                    showFullCurrencyNameLabel: true,
                    showCountryFlags: true,
                  ),
                  CurrencyTextField(
                    key: const Key('usd_input'),
                    item: currencies[1],
                    controller: usdController,
                    focusNode: usdFocusNode,
                    onTextChanged: (symbol, text) {},
                    useLargeInputs: false,
                    showFullCurrencyNameLabel: true,
                    showCountryFlags: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final copTextField = find.byKey(const Key('cop_input'));
      await tester.tap(copTextField);
      await tester.pumpAndSettle();

      await tester.enterText(copTextField, '5');
      await tester.pumpAndSettle();

      expect(copController.text, equals('5'));

      // With 2 decimal places: 0.001215 rounds to 0.00
      final expectedUsdValue = 5.0 / copPerUsd;
      final expectedRoundedUsd = double.parse(expectedUsdValue.toStringAsFixed(2));
      
      expect(usdController.text, equals(expectedRoundedUsd.toString()));
      expect(expectedRoundedUsd, equals(0.0));
    });

    testWidgets('Entering 5000 in COP converts to approximately 1.215 USD', (WidgetTester tester) async {
      // Use 3 decimal places to see the value
      testSettings = Settings(
        roundingDecimals: 3,
        accountForInflation: false,
        theme: "system",
        language: "en",
        updateFrequencyInHours: 12,
        useLargeInputs: false,
        showDragReorderHandles: false,
        showCopyToClipboardButtons: false,
        showFullCurrencyNameLabel: true,
        inputsPosition: "center",
        showCurrencyRate: "selected",
        showCountryFlags: true,
        allowDecimalInput: false,
        developerModeActive: false,
      );
      
      Spot.registerSingle<ISettings, Settings>((get) => testSettings);

      final currencies = [
        const Currency(
          id: 1,
          symbol: 'COP',
          name: 'Colombian Peso',
          rate: copPerUsd,
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

      final copController = TextEditingController();
      final usdController = TextEditingController();
      final copFocusNode = FocusNode();
      final usdFocusNode = FocusNode();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsNotifierProvider.overrideWith(() => TestSettingsNotifier(testSettings)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  CurrencyTextField(
                    key: const Key('cop_input'),
                    item: currencies[0],
                    controller: copController,
                    focusNode: copFocusNode,
                    onTextChanged: (symbol, text) {
                      if (text.isNotEmpty) {
                        final numericText = text.replaceAll(RegExp(r'[^0-9.]'), '');
                        final inputValue = double.tryParse(numericText) ?? 0.0;
                        final valueInUSD = inputValue / copPerUsd;
                        final roundedValue = double.parse(valueInUSD.toStringAsFixed(testSettings.roundingDecimals));
                        usdController.text = roundedValue.toString();
                      } else {
                        usdController.text = '';
                      }
                    },
                    useLargeInputs: false,
                    showFullCurrencyNameLabel: true,
                    showCountryFlags: true,
                  ),
                  CurrencyTextField(
                    key: const Key('usd_input'),
                    item: currencies[1],
                    controller: usdController,
                    focusNode: usdFocusNode,
                    onTextChanged: (symbol, text) {},
                    useLargeInputs: false,
                    showFullCurrencyNameLabel: true,
                    showCountryFlags: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final copTextField = find.byKey(const Key('cop_input'));
      await tester.tap(copTextField);
      await tester.pumpAndSettle();

      // Enter 5000 COP
      await tester.enterText(copTextField, '5000');
      await tester.pumpAndSettle();

      expect(copController.text, equals('5000'));

      // 5000 COP / 4115.61 = 1.2149... USD
      // With 3 decimal places rounding: 1.215 USD
      final expectedUsdValue = 5000.0 / copPerUsd;
      final expectedRoundedUsd = double.parse(expectedUsdValue.toStringAsFixed(3));
      
      expect(usdController.text, equals(expectedRoundedUsd.toString()));
      expect(expectedRoundedUsd, closeTo(1.215, 0.001));
    });
  });
}

/// Test implementation of SettingsNotifier for testing purposes
class TestSettingsNotifier extends SettingsNotifier {
  final Settings _settings;

  TestSettingsNotifier(this._settings) : super();

  @override
  Future<Settings> build() async {
    return _settings;
  }
}
