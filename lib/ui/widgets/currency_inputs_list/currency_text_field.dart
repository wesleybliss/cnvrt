import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/theme.dart';
import 'package:cnvrt/utils/currency_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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

class CurrencyTextField extends ConsumerWidget {
  final Currency item;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String, String) onTextChanged;
  final bool useLargeInputs;
  final bool showFullCurrencyNameLabel;
  final bool showCountryFlags;

  const CurrencyTextField({
    super.key,
    required this.item,
    required this.controller,
    required this.focusNode,
    required this.onTextChanged,
    this.useLargeInputs = false,
    this.showFullCurrencyNameLabel = true,
    this.showCountryFlags = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowDecimalInput = ref.watch(
      settingsNotifierProvider.select(
        (s) => s.value?.allowDecimalInput ?? false,
      ),
    );

    final labelFontSize = useLargeInputs ? 16.0 : 12.0;
    final inputFontSize = useLargeInputs ? 20.0 : 12.0;

    final prefixText =
        showCountryFlags
            ? "${currencyFlags[item.symbol]}  ${item.symbol}"
            : item.symbol;
    final prefixIcon = Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            prefixText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withAlpha(90), // Dimmer text
              fontSize: labelFontSize,
            ),
          ),
        ],
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
                      style: TextStyle(
                        fontSize: labelFontSize,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )
            : null;

    final decoration = defaultInputDecoration.copyWith(
      hintText: allowDecimalInput ? "0.00" : "0",
      prefixIcon: prefixIcon,
      label: label,
      labelStyle: TextStyle(fontSize: labelFontSize),
    );

    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      textAlign: TextAlign.end,
      style: TextStyle(fontFamily: 'monospace', fontSize: inputFontSize),
      keyboardType:
          allowDecimalInput
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
      inputFormatters: [
        // When decimals are allowed, use DecimalTextInputFormatter to allow decimal point
        // When decimals are not allowed, use digitsOnly to block decimal point
        if (allowDecimalInput)
          DecimalTextInputFormatter()
        else
          FilteringTextInputFormatter.digitsOnly,
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
