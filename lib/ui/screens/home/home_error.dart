import 'package:cnvrt/domain/di/providers/state/currencies_provider.dart';
import 'package:cnvrt/ui/screens/home/widgets/no_internet_error.dart';
import 'package:cnvrt/ui/widgets/unknown_error.dart';
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
        state.error?.contains("DioException") == true &&
        (state.error?.contains("Connection refused") == true ||
            state.error?.contains("Connection closed before") == true);

    Widget errorView =
        isConnectionError
            ? NoInternetError(onRetryClick: onFetchCurrenciesClick)
            : UnknownError(message: state.error ?? '');

    return Center(child: errorView);
  }
}
