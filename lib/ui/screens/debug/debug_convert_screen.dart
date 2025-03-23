import 'package:cnvrt/theme.dart';
import 'package:cnvrt/utils/currency_formatter.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter2 extends TextInputFormatter {
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

    // Convert to double and format as currency
    int value = int.parse(newText); // / 100;
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '');
    String formattedValue = formatter.format(value);

    return TextEditingValue(text: formattedValue, selection: TextSelection.collapsed(offset: formattedValue.length));
  }
}

class DebugConvertScreen extends ConsumerStatefulWidget {
  const DebugConvertScreen({super.key});

  @override
  ConsumerState<DebugConvertScreen> createState() => _DebugConvertScreenState();
}

class _DebugConvertScreenState extends ConsumerState<DebugConvertScreen> {
  final log = Logger('DebugConvertScreen');
  final inputController = TextEditingController();
  final outputController = TextEditingController();

  Widget labelFor(String text) => Align(
    alignment: Alignment.centerRight,
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(text, textAlign: TextAlign.end, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final inputDecoration = defaultInputDecoration.copyWith(
      hintText: "0.00",
      prefix: Text("INPUT"),
      labelStyle: TextStyle(fontSize: 12),
    );

    final outputDecoration = defaultInputDecoration.copyWith(
      hintText: "0.00",
      prefix: Text("OUTPUT"),
      labelStyle: TextStyle(fontSize: 12),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            TextField(
              controller: inputController,
              decoration: inputDecoration,
              textAlign: TextAlign.end,
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              keyboardType: TextInputType.number,
              inputFormatters: [
                // FilteringTextInputFormatter.digitsOnly,
                // DecimalTextInputFormatter(),
                // CurrencyInputFormatter(item.symbol),

                // CurrencyTextInputFormatter(currencyCode: item.symbol),
                FilteringTextInputFormatter.digitsOnly,
                CurrencyFormatter(currencySymbol: "USD"),
              ],
              onChanged: (text) {
                outputController.text = (double.parse(text) * 100.0).toString();
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: inputController,
              decoration: outputDecoration,
              textAlign: TextAlign.end,
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              keyboardType: TextInputType.number,
              inputFormatters: [
                // FilteringTextInputFormatter.digitsOnly,
                // DecimalTextInputFormatter(),
                // CurrencyInputFormatter(item.symbol),

                // CurrencyTextInputFormatter(currencyCode: item.symbol),
                FilteringTextInputFormatter.digitsOnly,
                CurrencyFormatter(currencySymbol: "COP"),
              ],
              onChanged: (text) {
                // log.d('@todo Handle change ${item.symbol} - $text');
              },
            ),
            ElevatedButton(
              onPressed: () {
                inputController.clear();
                outputController.clear();
              },
              child: Text("CLEAR"),
            ),
          ],
        ),
      ),
    );
  }
}
