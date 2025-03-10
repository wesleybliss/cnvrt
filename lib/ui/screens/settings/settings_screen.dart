import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:cnvrt/domain/di/providers/settings_provider.dart';
import 'package:cnvrt/io/settings.dart';
import 'package:cnvrt/ui/screens/settings/widgets/use_large_inputs_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final settingsAsyncValue = ref.watch(settingsNotifierProvider);
    final Map<String, TextEditingController> controllers = {"roundingDecimalsController": TextEditingController()};

    /*for (var i = 0; i < 3; i++) {
      controllers.putIfAbsent("controller-$i", () => TextEditingController());
    }*/

    @override
    void dispose() {
      for (var controller in controllers.values) {
        controller.dispose();
      }
      super.dispose();
    }

    Widget renderBody(Settings settings) {
      return Column(
        children: [
          ThemeDropdown(value: settings.theme),
          RoundDecimalsToInput(controller: controllers["roundingDecimalsController"]),
          UpdateFrequencyInHoursDropdown(value: settings.updateFrequencyInHours),
          UseLargeInputsSwitch(value: settings.useLargeInputs),
          ShowDragReorderHandlesSwitch(value: settings.showDragReorderHandles),
          ShowCopyToClipboardButtonsSwitch(value: settings.showCopyToClipboardButtons),
          ShowFullCurrencyNameLabelSwitch(value: settings.showFullCurrencyNameLabel),
          InputsPositionDropdown(value: settings.inputsPosition),
          ShowCurrencyRateDropdown(value: settings.showCurrencyRate),
          ElevatedButton(
            onPressed: () {
              // Handle settings action
              print('Settings pressed');
              Application.router.navigateTo(context, Routes.currencies);
            },
            child: const Text('Currencies'),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report), // Heart icon for favorites
            tooltip: 'Debug',
            onPressed: () {
              Application.router.navigateTo(context, Routes.debug);
            },
          ),
        ],
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
