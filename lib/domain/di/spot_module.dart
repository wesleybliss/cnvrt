import 'package:cnvrt/db/repos/currencies_repo.dart';
import 'package:cnvrt/domain/di/spot.dart';
import 'package:cnvrt/domain/io/i_settings.dart';
import 'package:cnvrt/domain/io/net/dio_client.dart';
import 'package:cnvrt/domain/io/net/i_dio_client.dart';
import 'package:cnvrt/domain/io/repos/i_currencies_repo.dart';
import 'package:cnvrt/domain/io/services/currencies_service.dart';
import 'package:cnvrt/domain/io/services/i_currencies_service.dart';
import 'package:cnvrt/io/settings.dart';
import 'package:dio/dio.dart';

abstract class SpotModule {
  static void registerDependencies() {
    Spot.init((factory, single) {
      // Globals
      single<ISettings, Settings>((get) => Settings());

      // Networking
      single<Dio, Dio>((get) => Dio());
      single<IDioClient, DioClient>((get) => DioClient());

      // DAOs
      // single<AUserDao, AUserDao>((get) => UserDao());

      // Repositories
      factory<ICurrenciesRepo, CurrenciesRepo>((get) => CurrenciesRepo());

      // Services
      single<ICurrenciesService, CurrenciesService>((get) => CurrenciesService(get<IDioClient>()));

      // Core Services
      // factory<IAuthService, AuthService>((get) => AuthService());
    });
  }
}

abstract class TestSpotModule extends SpotModule {
  static void registerDependencies() {
    Spot.init((factory, single) {

    });
  }
}
