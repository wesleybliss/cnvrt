import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/extensions/extensions.dart';
import 'package:cnvrt/ui/widgets/currency_inputs_list/currency_text_field.dart';
import 'package:flutter/material.dart';

class CurrencyInputsListRow extends StatelessWidget {
  final Currency item;
  final TextEditingController? controller;
  final void Function(String) onFocusChanged;
  final void Function(String, String) onTextChanged;
  final bool useLargeInputs;
  final bool showCopyToClipboardButtons;
  final bool showFullCurrencyNameLabel;
  final bool showCountryFlags;

  const CurrencyInputsListRow({
    super.key,
    required this.item,
    required this.controller,
    required this.onFocusChanged,
    required this.onTextChanged,

    this.useLargeInputs = false,
    this.showCopyToClipboardButtons = true,
    this.showFullCurrencyNameLabel = true,
    this.showCountryFlags = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                onFocusChanged(item.symbol);
              }
            },
            child: CurrencyTextField(
              item: item,
              controller: controller,
              onTextChanged: onTextChanged,
              useLargeInputs: useLargeInputs,
              showFullCurrencyNameLabel: showFullCurrencyNameLabel,
              showCountryFlags: showCountryFlags,
            ),
          ),
        ),
        if (showCopyToClipboardButtons)
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () {
              context.copyToClipboard(controller?.text ?? '');
            },
          ),
      ],
    );
  }
}
