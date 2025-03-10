import 'package:cnvrt/config/routing/routes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/domain/di/providers/settings_provider.dart';
import 'package:cnvrt/domain/di/providers/state/currencies_provider.dart';
import 'package:cnvrt/domain/models/currency.dart';
import 'package:cnvrt/io/settings.dart';
import 'package:cnvrt/store/SimpleCurrencyStore.dart';
import 'package:cnvrt/utils/logger.dart';

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  final log = Logger('DebugScreen');

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currenciesProvider);
    final settingsAsyncValue = ref.watch(settingsNotifierProvider);
    final selectedCurrencies = ref.watch(selectedCurrenciesProvider);

    void debugCheckStorage() async {
      final currencyBox = store.box<Currency>();
      final items = await currencyBox.getAllAsync();
      log.d('Currency items: ${items.length}');
      log.d('Selected Currencies: $selectedCurrencies');
    }

    void debugAutoSelectDefaults() async {
      final currencyBox = store.box<Currency>();
      final items = await currencyBox.getAllAsync();
      final symbols = ['USD', 'COP', 'MXN'];

      for (var symbol in symbols) {
        final it = items.firstWhereOrNull((e) => e.symbol == symbol);
        if (it != null) {
          currencyBox.put(it.copyWith(selected: true));
        } else {
          log.e('Symbol not found: $symbol');
        }
      }

      ref.read(currenciesProvider.notifier).readCurrencies();
    }

    void debugReportStatus() async {
      log.d('HomeReady: ${state.currencies.length} total');
      log.d('HomeReady: ${selectedCurrencies.length} selected');
    }

    void onFetchCurrenciesClick() {
      ref.read(currenciesProvider.notifier).fetchCurrencies();
    }

    void onClearCurrenciesClick() {
      ref.read(currenciesProvider.notifier).fetchCurrencies();
    }

    final debugButton = ElevatedButton(
      onPressed: debugCheckStorage,
      child: Text('Debug Check Storage: ${state.currencies.length}'),
    );

    Widget renderBody(Settings settings) {
      return Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            ListTile(
              title: const Text('theme'),
              trailing: Text(settings.theme),
            ),
            ListTile(
              title: const Text('showDragReorderHandles'),
              trailing: Text(settings.showDragReorderHandles.toString()),
            ),
            ListTile(
              title: const Text('showCopyToClipboardButtons'),
              trailing: Text(settings.showCopyToClipboardButtons.toString()),
            ),
            ListTile(
              title: const Text('showFullCurrencyNameLabel'),
              trailing: Text(settings.showFullCurrencyNameLabel.toString()),
            ),
            ListTile(
              title: const Text('inputsPosition'),
              trailing: Text(settings.inputsPosition.toString()),
            ),
            ListTile(
              title: const Text('showCurrencyRate'),
              trailing: Text(settings.showCurrencyRate.toString()),
            ),
            TextButton(
              onPressed: () => Application.router.navigateTo(context, Routes.currencies),
              child: const Text('Manage Currencies'),
            ),
            TextButton(
              onPressed: onFetchCurrenciesClick,
              child: const Text('Fetch Currencies'),
            ),
            ElevatedButton(
              onPressed: debugCheckStorage,
              child: Text('Debug Check Storage: ${state.currencies.length}'),
            ),
            ElevatedButton(
              onPressed: onClearCurrenciesClick,
              child: const Text('Clear Currencies'),
            ),
            ElevatedButton(
              onPressed: debugAutoSelectDefaults,
              child: const Text('Debug auto select defaults'),
            ),
            ElevatedButton(
              onPressed: debugReportStatus,
              child: const Text('Debug report status'),
            ),
          ]));
    }

    return settingsAsyncValue.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Error: $error'),
        data: (settings) {
          return renderBody(settings);
        });
  }
}
