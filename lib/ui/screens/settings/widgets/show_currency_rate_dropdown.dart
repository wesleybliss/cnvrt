import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowCurrencyRateDropdown extends ConsumerWidget {
  final String value;

  const ShowCurrencyRateDropdown({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdown = DropdownButton(
      value: value,
      items: [
        DropdownMenuItem(value: "all", child: Text(AppLocalizations.of(context)!.all)),
        DropdownMenuItem(value: "selected", child: Text(AppLocalizations.of(context)!.selected)),
        DropdownMenuItem(value: "none", child: Text(AppLocalizations.of(context)!.none)),
      ],
      onChanged: (String? value) {
        ref.read(settingsNotifierProvider.notifier).setShowCurrencyRate(value ?? "selected");
      },
      hint: Text(AppLocalizations.of(context)!.selectAnOption),
    );

    return ListTile(
      title: Text(AppLocalizations.of(context)!.showCurrentRates),
      leading: Icon(Icons.message),
      trailing: dropdown,
    );
  }
}
