import 'package:cnvrt/domain/io/net/dio_client.dart';
import 'package:cnvrt/domain/io/services/i_currencies_service.dart';
import 'package:cnvrt/domain/models/currency_response.dart';
import 'package:cnvrt/utils/crashlytics_utils.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:cnvrt/utils/network_utils.dart';

class CurrenciesService implements ICurrenciesService {
  CurrenciesService(this.dio);

  @override
  final log = Logger('CurrenciesService');

  @override
  final DioClient dio;

  /// Fetches currencies from API with automatic retry on connectivity errors.
  /// Retries up to 3 times with 1s, 2s, 3s delays for connectivity issues.
  /// Non-connectivity errors are reported to Crashlytics and thrown immediately.
  @override
  Future<CurrencyResponse?> fetchCurrencies() async {
    const delays = [Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 3)];
    
    for (var attempt = 0; attempt <= delays.length; attempt++) {
      try {
        return await _fetchCurrenciesInternal();
      } catch (e, st) {
        final isLastAttempt = attempt == delays.length;
        final isConnectivity = isConnectivityError(e);
        
        // If it's not a connectivity error, report and rethrow immediately
        if (!isConnectivity) {
          log.e('Non-connectivity error fetching currencies', e);
          await recordNonConnectivityError(e, st);
          rethrow;
        }
        
        // If it's a connectivity error and we're on the last attempt, rethrow
        if (isLastAttempt) {
          log.w('Connectivity error on last attempt. Giving up.');
          rethrow;
        }
        
        // Otherwise, log and retry after delay
        final delay = delays[attempt];
        log.w('Connectivity error on attempt ${attempt + 1}. Retrying in ${delay.inSeconds}s...');
        await Future.delayed(delay);
      }
    }
    
    throw StateError('Unreachable: retry loop should always return or rethrow');
  }
  
  Future<CurrencyResponse?> _fetchCurrenciesInternal() async {
    log.d('getCurrencies');

    final res = await dio.get('/currencies');
    final data = res.data == null ? null : CurrencyResponse.fromJson(res.data);

    log.d('CurrenciesNotifier response: got ${data?.data.currencies.length ?? 0} currencies');

    return data;
  }
}
