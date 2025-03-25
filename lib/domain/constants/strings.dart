class ConstantsStrings {
  // final appName = 'Simple Currency';
  final appName = 'CNVRT';
  final appSlug = 'simple-currency';

  String get baseUrl {
    const bool isProduction = bool.fromEnvironment('dart.vm.product');

    if (isProduction) {
      return 'https://simple-currency-cron.vercel.app/api';
    } else {
      return 'http://localhost:3002/api';
    }
  }
}
