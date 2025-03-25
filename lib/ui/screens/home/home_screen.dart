import 'package:cnvrt/domain/di/providers/state/currencies_provider.dart';
import 'package:cnvrt/ui/screens/home/home_error.dart';
import 'package:cnvrt/ui/screens/home/home_loading.dart';
import 'package:cnvrt/ui/screens/home/home_ready.dart';
import 'package:cnvrt/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Utils.nextTick(() {
      // Read local currencies & refresh if needed
      ref.read(currenciesProvider.notifier).initializeCurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currenciesProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(currenciesProvider.notifier).fetchCurrencies();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // Ensures the scroll area is always scrollable
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Makes the child take up the full screen height
          child:
              state.loading
                  ? state.currencies.isNotEmpty
                      ? const HomeReady()
                      : HomeLoading(isFetching: state.isFetching)
                  : state.error != null
                  ? const HomeError()
                  : const HomeReady(),
        ),
      ),
    );
  }
}
