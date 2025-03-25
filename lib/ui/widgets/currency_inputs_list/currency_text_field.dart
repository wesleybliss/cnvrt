import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/theme.dart';
import 'package:cnvrt/utils/currency_flags.dart';
import 'package:cnvrt/utils/currency_formatter.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only digits and one decimal point
    if (newValue.text.isEmpty) {
      return newValue; // Allow empty input
    }

    // Regular expression to match valid decimal numbers
    final RegExp regex = RegExp(r'^\d*\.?\d*$');

    if (regex.hasMatch(newValue.text)) {
      return newValue; // If valid, return the new value
    }

    return oldValue; // If invalid, return the old value
  }
}

class CurrencyTextField extends StatelessWidget {
  final Currency item;
  final TextEditingController? controller;
  final void Function(String, String) onTextChanged;
  final bool useLargeInputs;
  final bool showFullCurrencyNameLabel;
  final bool showCountryFlags;

  const CurrencyTextField({
    super.key,
    required this.item,
    required this.controller,
    required this.onTextChanged,
    this.useLargeInputs = false,
    this.showFullCurrencyNameLabel = true,
    this.showCountryFlags = true,
  });

  @override
  Widget build(BuildContext context) {
    final log = Logger('CurrencyTextField');

    final labelFontSize = useLargeInputs ? 16.0 : 12.0;
    final inputFontSize = useLargeInputs ? 20.0 : 12.0;

    final prefixText = showCountryFlags ? "${currencyFlags[item.symbol]}  ${item.symbol}" : item.symbol;
    final prefix = Padding(
      padding: const EdgeInsets.only(right: 12.0), // Add space to the right of the prefix
      child: Text(
        prefixText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(90), // Dimmer text
          fontSize: labelFontSize,
        ),
      ),
    );

    final label =
        showFullCurrencyNameLabel
            ? Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      item.name,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: labelFontSize, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )
            : null;

    final decoration = defaultInputDecoration.copyWith(
      hintText: "0.00",
      prefix: prefix,
      label: label,
      labelStyle: TextStyle(fontSize: labelFontSize),
    );

    return TextField(
      controller: controller,
      decoration: decoration,
      textAlign: TextAlign.end,
      style: TextStyle(fontFamily: 'monospace', fontSize: inputFontSize),
      keyboardType: TextInputType.number,
      inputFormatters: [
        // FilteringTextInputFormatter.digitsOnly,
        // DecimalTextInputFormatter(),
        // CurrencyInputFormatter(item.symbol),

        // CurrencyTextInputFormatter(currencyCode: item.symbol),
        FilteringTextInputFormatter.digitsOnly,
        CurrencyFormatter(currencySymbol: item.symbol),
      ],
      onTap: () {
        controller?.clear();
      },
      onChanged: (text) {
        onTextChanged(item.symbol, text);
        // log.d('@todo Handle change ${item.symbol} - $text');
      },
    );
  }
}
