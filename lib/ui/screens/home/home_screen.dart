import 'dart:async';

import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/ui/screens/home/home_error.dart';
import 'package:cnvrt/ui/screens/home/home_loading.dart';
import 'package:cnvrt/ui/screens/home/home_ready.dart';
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
  bool _snackbarDismissedManually = false;

  @override
  void initState() {
    super.initState();

    Utils.nextTick(() {
      // Read local currencies & refresh if needed
      ref.read(currenciesProvider.notifier).initializeCurrencies();
    });

    // Listen to network error state changes
    ref.listenManual(currenciesProvider, (previous, next) {
      _handleNetworkErrorStateChange(next);
    });
  }

  @override
  void dispose() {
    _cancelAutoRetry();
    _hideSnackbar();
    super.dispose();
  }

  void _handleNetworkErrorStateChange(CurrenciesState state) {
    final hasError = state.hasNetworkError;
    final hasCache = state.currencies.isNotEmpty;

    if (hasError && hasCache && !_snackbarDismissedManually) {
      // Show snackbar and start auto-retry
      _showNetworkErrorSnackbar();
      _startAutoRetry();
    } else if (!hasError) {
      // Success: hide snackbar and cancel retry
      _cancelAutoRetry();
      _hideSnackbar();
      _snackbarDismissedManually = false;
    }
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
              Expanded(
                child: Text(l10n.unableToRefreshCurrencies),
              ),
              TextButton(
                onPressed: _onManualRetry,
                child: Text(l10n.retry),
              ),
              TextButton(
                onPressed: _onDismiss,
                child: Text(l10n.dismiss),
              ),
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

  void _startAutoRetry() {
    // Cancel any existing timer first
    _cancelAutoRetry();

    _autoRetryTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_snackbarDismissedManually) {
        ref.read(currenciesProvider.notifier).fetchCurrencies();
      }
    });
  }

  void _cancelAutoRetry() {
    _autoRetryTimer?.cancel();
    _autoRetryTimer = null;
  }

  void _onManualRetry() {
    _snackbarDismissedManually = false;
    _cancelAutoRetry();
    ref.read(currenciesProvider.notifier).fetchCurrencies();
  }

  void _onDismiss() {
    _snackbarDismissedManually = true;
    _cancelAutoRetry();
    _hideSnackbar();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currenciesProvider);

    final child = state.loading
        ? state.currencies.isNotEmpty
            ? const HomeReady()
            : HomeLoading(isFetching: state.isFetching)
        : state.error != null
        ? const HomeError()
        : const HomeReady();

    return RefreshIndicator(
      onRefresh: () async {
        _snackbarDismissedManually = false;
        ref.read(currenciesProvider.notifier).fetchCurrencies();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
