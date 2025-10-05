import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountForInflationSwitch extends ConsumerWidget {
  final bool value;

  const AccountForInflationSwitch({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.accountForInflation),
      subtitle: Text(AppLocalizations.of(context)!.accountForInflationDescription),
      value: value,
      onChanged: (bool value) {
        ref.read(settingsNotifierProvider.notifier).setAccountForInflation(value);
      },
      secondary: const Icon(Icons.area_chart),
    );
  }
}
