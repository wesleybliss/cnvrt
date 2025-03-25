import 'package:cnvrt/theme.dart';
import 'package:cnvrt/utils/currency_formatter.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
