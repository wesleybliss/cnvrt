import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/io/settings.dart';
import 'package:cnvrt/ui/screens/settings/widgets/ShowCountryFlagsSwitch.dart';
import 'package:cnvrt/ui/screens/settings/widgets/account_for_inflation_switch.dart';
import 'package:cnvrt/ui/screens/settings/widgets/allow_decimal_input_switch.dart';
import 'package:cnvrt/ui/screens/settings/widgets/language_dropdown.dart';
import 'package:cnvrt/ui/screens/settings/widgets/use_large_inputs_switch.dart';
import 'package:cnvrt/ui/widgets/tap_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'widgets/inputs_position_dropdown.dart';
import 'widgets/round_decimals_to_input.dart';
import 'widgets/show_copy_to_clipboard_buttons_switch.dart';
import 'widgets/show_currency_rate_dropdown.dart';
import 'widgets/show_drag_reorder_handles_switch.dart';
import 'widgets/show_full_currency_name_label_switch.dart';
import 'widgets/theme_dropdown.dart';
import 'widgets/update_frequency_in_hours_dropdown.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    String appVersion = '0.0.0';
    final settingsAsyncValue = ref.watch(settingsNotifierProvider);
    final Map<String, TextEditingController> controllers = {"roundingDecimalsController": TextEditingController()};

    void fetchAppVersion() async {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = 'Version ${info.version} (${info.buildNumber})';
      });
    }

    @override
    void initState() {
      super.initState();
      fetchAppVersion();
    }

    @override
    void dispose() {
      for (var controller in controllers.values) {
        controller.dispose();
      }
      super.dispose();
    }

    Widget renderBody(Settings settings) {
      final debugWidget =
          settings.developerModeActive
              ? IconButton(
                icon: const Icon(Icons.bug_report),
                tooltip: 'Debug',
                onPressed: () {
                  Application.router.navigateTo(context, Routes.debug);
                },
              )
              : TapCounter(
                label: appVersion,
                onTapCountReached: () async {
                  // Wait 3 seconds
                  await Future.delayed(const Duration(seconds: 3), () {
                    ref.read(settingsNotifierProvider.notifier).setDeveloperModeActive(true);
                  });
                },
              );

      return SingleChildScrollView(
        child: Column(
          children: [
            ThemeDropdown(value: settings.theme),
            LanguageDropdown(value: settings.language),
            RoundDecimalsToInput(controller: controllers["roundingDecimalsController"]),
            UpdateFrequencyInHoursDropdown(value: settings.updateFrequencyInHours),
            UseLargeInputsSwitch(value: settings.useLargeInputs),
            ShowDragReorderHandlesSwitch(value: settings.showDragReorderHandles),
            ShowCopyToClipboardButtonsSwitch(value: settings.showCopyToClipboardButtons),
            ShowFullCurrencyNameLabelSwitch(value: settings.showFullCurrencyNameLabel),
            InputsPositionDropdown(value: settings.inputsPosition),
            ShowCurrencyRateDropdown(value: settings.showCurrencyRate),
            AccountForInflationSwitch(value: settings.accountForInflation),
            ShowCountryFlagsSwitch(value: settings.showCountryFlags),
            AllowDecimalInputSwitch(value: settings.allowDecimalInput),
            Padding(padding: EdgeInsets.symmetric(vertical: 16), child: debugWidget),
          ],
        ),
      );
    }

    return settingsAsyncValue.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (settings) {
        // Set initial values
        controllers["roundingDecimalsController"]?.text = settings.roundingDecimals.toString();

        return renderBody(settings);
      },
    );
  }
}
