import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundDecimalsToInput extends ConsumerWidget {
  final TextEditingController? controller;

  const RoundDecimalsToInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Round decimals to'),
      leading: const Icon(Icons.numbers),
      trailing: SizedBox(
        width: 75,
        child: TextField(
          controller: controller,
          decoration: defaultInputDecoration,
          textAlign: TextAlign.end,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (text) {
            ref.read(settingsNotifierProvider.notifier).setRoundingDecimals(int.parse(text, radix: 10));
          },
        ),
      ),
    );
  }
}
