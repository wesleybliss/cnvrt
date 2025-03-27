import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericUnitsRowField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration decoration;
  final ValueChanged<String> onChanged;

  const NumericUnitsRowField({super.key, required this.controller, required this.decoration, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: TextField(
          controller: controller,
          decoration: decoration,
          textAlign: TextAlign.end,
          style: TextStyle(fontFamily: 'monospace', fontSize: 12),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
