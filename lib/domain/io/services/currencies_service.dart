import 'package:cnvrt/domain/io/net/dio_client.dart';
import 'package:cnvrt/domain/io/services/i_currencies_service.dart';
import 'package:cnvrt/domain/models/currency_response.dart';
import 'package:cnvrt/utils/logger.dart';

class CurrenciesService implements ICurrenciesService {
  CurrenciesService(this.dio);

  @override
  final log = Logger('CurrenciesService');

  @override
  final DioClient dio;

  @override
  Future<CurrencyResponse?> fetchCurrencies() async {
    log.d('getCurrencies');

    final res = await dio.get('/currencies');
    final data = res.data == null ? null : CurrencyResponse.fromJson(res.data);

    log.d('CurrenciesNotifier response: got ${data?.data.currencies.length ?? 0} currencies');

    return data;
  }
}
