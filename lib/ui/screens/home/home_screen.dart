import 'dart:async';

import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/domain/di/providers/notifications/notification_provider.dart';
import 'package:cnvrt/domain/extensions/extensions.dart';
import 'package:cnvrt/ui/screens/home/home_error.dart';
import 'package:cnvrt/ui/screens/home/home_loading.dart';
import 'package:cnvrt/ui/screens/home/home_ready.dart';
import 'package:cnvrt/ui/widgets/currency_inputs_list/currency_inputs_list_vm.dart';
import 'package:cnvrt/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _autoRetryTimer;
  bool _isSnackbarShown = false;
  int _retryCount = 0;
  static const int _maxRetryAttempts = 2;
  
  @override
  void initState() {
    super.initState();

    Utils.nextTick(() {
      // Read local currencies & refresh if needed
      ref.read(currenciesProvider.notifier).initializeCurrencies();
    });

    // Listen to network error state changes
    /*ref.listenManual(currenciesProvider, (previous, next) {
      _handleNetworkErrorStateChange(next);
    });*/
    
    // Listen to currency update notifications
    ref.listenManual(notificationNotifierProvider, (previous, next) {
      _handleCurrencyUpdateNotification(next);
    });
  }

  @override
  void dispose() {
    _cancelAutoRetry();
    _hideSnackbar();
    super.dispose();
  }

  Widget buildHomeView(CurrenciesState state) {
    if (state.error != null) return HomeError();
    if (state.loading) return HomeLoading(isFetching: state.isFetching);
    if (state.currencies.isNotEmpty) return HomeReady();

    // loading == false but no currencies in the DB — can happen transiently
    // during a rebuild (e.g. theme change) before initializeCurrencies() finishes
    // reading from SQLite.  Show a loading indicator instead of an empty HomeReady
    // so the user never sees "You don't have any currencies selected yet."
    // when their favourites are still on disk.
    return HomeLoading(isFetching: false);
  }

  void _handleNetworkErrorStateChange(CurrenciesState state) {
    final hasError = state.hasNetworkError;
    final hasCache = state.currencies.isNotEmpty;

    if (hasError && hasCache && !_isSnackbarShown) {
      // Show snackbar and start auto-retry (first attempt)
      _showNetworkErrorSnackbar();
      _retryCount = 0;
      _startAutoRetry();
    } else if (!hasError) {
      // Success: hide snackbar and cancel retry
      _cancelAutoRetry();
      _hideSnackbar();
      _isSnackbarShown = false;
      _retryCount = 0;
    }
    // Note: if we are already showing the snackbar and we get another error,
    // we do not show the snackbar again, but we may still want to auto-retry
    // if we haven't exceeded the max attempts. This is handled in _startAutoRetry
    // which is called from _onManualRetry and from the timer.
  }

  void _showNetworkErrorSnackbar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(days: 365), // Effectively indefinite
          content: Row(
            children: [
              Expanded(child: Text(l10n.unableToRefreshCurrencies)),
              TextButton(onPressed: _onManualRetry, child: Text(l10n.retry)),
              TextButton(onPressed: _onDismiss, child: Text(l10n.dismiss)),
            ],
          ),
        ),
      );
    });
  }

  void _hideSnackbar() {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _handleCurrencyUpdateNotification(NotificationState state) {
    final notification = state.currencyUpdateNotification;
    if (notification != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        context.snackBar(
          notification.message,
          behavior: SnackBarBehavior.floating,
        );

        // Clear the notification after showing it
        ref
            .read(notificationNotifierProvider.notifier)
            .clearCurrencyUpdateNotification();
      });
    }
  }

  void _startAutoRetry() {
    // Cancel any existing timer first
    _cancelAutoRetry();

    // If we haven't reached the max retry attempts, schedule a retry
    if (_retryCount < _maxRetryAttempts) {
      _retryCount++;
      _autoRetryTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isSnackbarShown) {
          // Note: we check _isSnackbarShown because the user might have dismissed
          // the snackbar while we were waiting for the timer.
          ref.read(currenciesProvider.notifier).fetchCurrencies();
        }
      });
    }
    // If we have reached the max attempts, we do nothing (no timer set)
  }

  void _cancelAutoRetry() {
    _autoRetryTimer?.cancel();
    _autoRetryTimer = null;
  }

  void _onManualRetry() {
    _isSnackbarShown = false;
    _cancelAutoRetry();
    ref.read(currenciesProvider.notifier).fetchCurrencies();
  }

  void _onDismiss() {
    _isSnackbarShown = false;
    _cancelAutoRetry();
    _hideSnackbar();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currenciesProvider);

    // Listen for the state to become ready to trigger autofocus.
    // Re-registering on every build() is safe: Riverpod saves and replaces
    // the previous one-shot subscription so there is never a leak.
    ref.listen(currenciesProvider, (previous, next) {
      final hadData = previous?.currencies.isNotEmpty ?? false;
      final hasData = next.currencies.isNotEmpty;
      final wasLoading = previous?.loading ?? true;
      final isNowReady = !next.loading;

      // Trigger focus if we just got data or just finished a loading state
      if (hasData && (!hadData || (wasLoading && isNowReady))) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final focusedSymbol = ref.read(focusedCurrencyInputSymbolProvider);
          final vm = ref.read(currencyInputsListViewModelProvider.notifier);

          if (focusedSymbol != null) {
            // Re-focus the last focused input after data update
            vm.requestFocus(focusedSymbol);
          } else {
            // Default to focusing the first one if nothing was focused
            vm.requestFocusOnFirst();
          }
        });
      }
    });

    final child = buildHomeView(state);

    return RefreshIndicator(
      onRefresh: () async {
        _isSnackbarShown = false;
        ref.read(currenciesProvider.notifier).fetchCurrencies();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Good for most tablets, to constrain max width
          const double maxContentWidth = 800;

          double contentWidth = constraints.maxWidth;

          if (contentWidth > maxContentWidth) {
            contentWidth = maxContentWidth;
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  maxWidth: contentWidth,
                ),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
