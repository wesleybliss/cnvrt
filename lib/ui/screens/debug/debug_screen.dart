import 'package:cnvrt/config/application.dart';
import 'package:cnvrt/config/routing/routes.dart';
import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/settings/settings_provider.dart';
import 'package:cnvrt/domain/io/repos/i_currencies_repo.dart';
import 'package:cnvrt/io/settings.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spot_di/spot_di.dart';

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

    // Currency debug functions
    void debugCheckStorage() async {
      final currenciesRepo = spot<ICurrenciesRepo>();
      final items = await currenciesRepo.findAll();
      log.d('Currency items: ${items.length}');
      log.d('Selected Currencies: $selectedCurrencies');
    }

    void debugAutoSelectDefaults() async {
      final currenciesRepo = spot<ICurrenciesRepo>();
      final items = await currenciesRepo.findAll();
      final symbols = ['USD', 'COP', 'MXN'];

      for (var symbol in symbols) {
        final it = items.firstWhereOrNull((e) => e.symbol == symbol);
        if (it != null) {
          currenciesRepo.update(it.copyWith(selected: true));
        } else {
          log.e('Symbol not found: $symbol');
        }
      }

      ref.read(currenciesProvider.notifier).readCurrencies();
    }

    void debugReportStatus() async {
      log.d('Status: ${state.currencies.length} total, ${selectedCurrencies.length} selected');
    }

    void debugDumpAllCurrencies() {
      log.d('\n${state.currencies.map((it) => '${it.symbol}, ${it.name}').join('\n')}\n');
    }

    void onFetchCurrenciesClick() {
      ref.read(currenciesProvider.notifier).fetchCurrencies();
    }

    Future<void> onClearCurrenciesClick() async {
      final currenciesRepo = spot<ICurrenciesRepo>();
      await currenciesRepo.deleteAll();
      ref.read(currenciesProvider.notifier).fetchCurrencies();
    }

    // Crashlytics test functions
    void testNonFatalError() async {
      try {
        throw Exception('Testing');
      } catch (error, stackTrace) {
        log.i('Recording non-fatal test error to Crashlytics: $error');
        print('[Crashlytics Test] Sending non-fatal error...');
        
        // Check if Crashlytics is enabled
        final isEnabled = FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;
        print('[Crashlytics Test] Crashlytics enabled: $isEnabled');
        
        await FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: false,
          reason: 'Test non-fatal error from debug screen',
        );
        
        print('[Crashlytics Test] Error recorded successfully');
        print('[Crashlytics Test] Restart app to upload to Firebase');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error logged! Crashlytics ${isEnabled ? "enabled" : "DISABLED"}. Restart app to send.'),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }

    void testFatalCrash() {
      log.w('Triggering fatal crash test - app will crash!');
      print('[Crashlytics Test] Forcing fatal crash...');
      // This will cause an actual crash
      FirebaseCrashlytics.instance.crash();
    }

    Widget buildSectionHeader(BuildContext context, String title) {
      return Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      );
    }

    Widget buildNavigationButton(BuildContext context, String label, String route) {
      return OutlinedButton(
        onPressed: () => Application.router.navigateTo(context, route),
        child: Text(label),
      );
    }

    Widget buildSettingRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    Widget renderBody(Settings settings) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Debug Tools',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Debug Screens Section
              buildSectionHeader(context, '🎨 Debug Screens'),
              const SizedBox(height: 8),
              buildNavigationButton(
                context,
                'Theme Debug',
                Routes.debugTheme,
              ),
              buildNavigationButton(
                context,
                'Convert Debug',
                Routes.debugConvert,
              ),
              buildNavigationButton(
                context,
                'SQL Test Debug',
                Routes.debugSqlTest,
              ),
              const SizedBox(height: 24),

              // Current Settings Section
              buildSectionHeader(context, '⚙️ Current Settings'),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildSettingRow('Theme', settings.theme),
                      buildSettingRow('Drag Handles', settings.showDragReorderHandles.toString()),
                      buildSettingRow('Clipboard Buttons', settings.showCopyToClipboardButtons.toString()),
                      buildSettingRow('Full Currency Names', settings.showFullCurrencyNameLabel.toString()),
                      buildSettingRow('Inputs Position', settings.inputsPosition.toString()),
                      buildSettingRow('Show Currency Rate', settings.showCurrencyRate.toString()),
                      buildSettingRow('Account for Inflation', settings.accountForInflation.toString()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Currency Actions Section
              buildSectionHeader(context, '💱 Currency Actions'),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => Application.router.navigateTo(context, Routes.currencies),
                icon: const Icon(Icons.manage_search),
                label: const Text('Manage Currencies'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: onFetchCurrenciesClick,
                icon: const Icon(Icons.refresh),
                label: const Text('Fetch Currencies'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: debugCheckStorage,
                icon: const Icon(Icons.storage),
                label: Text('Check Storage (${state.currencies.length} items)'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: onClearCurrenciesClick,
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Clear All Currencies'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
              ),
              const SizedBox(height: 24),

              // Debug Logging Section
              buildSectionHeader(context, '🐛 Debug Logging'),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: debugAutoSelectDefaults,
                child: const Text('Auto-select Default Currencies'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: debugReportStatus,
                child: const Text('Report Status to Console'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: debugDumpAllCurrencies,
                child: const Text('Dump All Currencies to Console'),
              ),
              const SizedBox(height: 24),

              // Error Screen Testing Section
              buildSectionHeader(context, '❌ Error Screen Testing'),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // Create a test exception with stack trace
                  try {
                    throw Exception('This is a test error for the error screen');
                  } catch (error, stackTrace) {
                    // Navigate to error screen with the exception
                    Application.router.navigateTo(
                      context,
                      '${Routes.error}?test=true',
                      routeSettings: RouteSettings(
                        arguments: {
                          'error': error as Exception,
                          'stackTrace': stackTrace,
                        },
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.error_outline),
                label: const Text('Test Error Screen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Error Screen Testing Section
              buildSectionHeader(context, '❌ Error Screen Testing'),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to error screen with a test error message
                  final errorMessage = Uri.encodeComponent(
                    'This is a test error for the error screen',
                  );
                  Application.router.navigateTo(
                    context,
                    '${Routes.error}?message=$errorMessage',
                  );
                },
                icon: const Icon(Icons.error_outline),
                label: const Text('Test Error Screen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Crashlytics Section
              buildSectionHeader(context, '🔥 Firebase Crashlytics'),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: testNonFatalError,
                icon: const Icon(Icons.bug_report),
                label: const Text('Test Non-Fatal Error'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: testFatalCrash,
                icon: const Icon(Icons.warning),
                label: const Text('Test Fatal Crash (App Will Close!)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Testing Instructions:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Non-Fatal: Logs error, restart app to upload',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '• Fatal Crash: App crashes immediately, report sent on next launch',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check Firebase Console in 5-10 minutes after test.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }

    return settingsAsyncValue.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (settings) {
        return renderBody(settings);
      },
    );
  }
}
