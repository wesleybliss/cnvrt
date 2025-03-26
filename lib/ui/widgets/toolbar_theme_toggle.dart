import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_selectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToolbarThemeToggle extends ConsumerWidget {
  const ToolbarThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsyncValue = ref.watch(themeProvider);

    return themeAsyncValue.when(
      loading: () => const Text(''),
      error: (error, stackTrace) => const Text(''),
      data: (theme) {
        final themeMode =
            theme == "system"
                ? ThemeMode.system
                : theme == "dark"
                ? ThemeMode.dark
                : ThemeMode.light;

        return IconButton(
          icon:
              themeMode == ThemeMode.system
                  ? const Icon(Icons.auto_mode)
                  : themeMode == ThemeMode.light
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode),
          tooltip: 'Debug',
          onPressed: () {
            ref.read(settingsNotifierProvider.notifier).cycleNextTheme();
          },
        );
      },
    );
  }
}
