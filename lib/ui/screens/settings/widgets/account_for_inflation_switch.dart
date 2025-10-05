import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountForInflationSwitch extends ConsumerWidget {
  final bool value;

  const AccountForInflationSwitch({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.area_chart),
      title: Row(
        children: [
          Expanded(
            child: Text(AppLocalizations.of(context)!.accountForInflation),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Application.router.navigateTo(context, Routes.inflationHelp);
            },
            tooltip: 'Help',
          ),
        ],
      ),
      subtitle: Text(AppLocalizations.of(context)!.accountForInflationDescription),
      trailing: Switch(
        value: value,
        onChanged: (bool value) {
          ref.read(settingsNotifierProvider.notifier).setAccountForInflation(value);
        },
      ),
    );
  }
}
