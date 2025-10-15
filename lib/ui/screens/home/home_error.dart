import 'package:cnvrt/domain/di/providers/currencies/currencies_provider.dart';
import 'package:cnvrt/ui/screens/error/error_screen.dart';
import 'package:cnvrt/ui/screens/home/widgets/no_internet_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeError extends ConsumerWidget {
  const HomeError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currenciesProvider);

    void onFetchCurrenciesClick() {
      ref.read(currenciesProvider.notifier).fetchCurrencies();
    }

    final bool isConnectionError =
        state.error?.toString().contains("DioException") == true &&
        (state.error?.toString().contains("Connection refused") == true ||
            state.error?.toString().contains("Connection closed before") == true);

    Widget errorView =
        isConnectionError
            ? NoInternetError(onRetryClick: onFetchCurrenciesClick)
            : ErrorScreen(error: state.error);

    return Center(child: errorView);
  }
}
