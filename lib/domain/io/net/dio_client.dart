import 'package:dio/dio.dart';
import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/domain/io/net/i_dio_client.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient implements IDioClient {
  
  @override
  final log = Logger('DioClient');
  
  @override
  final Dio dio;

  DioClient() : dio = Dio(BaseOptions(
    baseUrl: Constants.strings.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  )) {
    dio.interceptors.add(LogInterceptor(responseBody: true)); // Optional logging
  }
  
  @override
  Future<Response> get(String path) async {
    log.d('GET $path');
    
    // Check if caching is disabled for debugging
    final prefs = await SharedPreferences.getInstance();
    final disableCache = prefs.getBool(Constants.keys.settings.disableCurrencyCaching) ?? false;
    
    Options? options;
    String finalPath = path;
    
    if (disableCache) {
      log.d('HTTP caching disabled - adding cache-busting headers and timestamp');
      options = Options(
        headers: {
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      );
      
      // Add timestamp query parameter to bust cache
      final separator = path.contains('?') ? '&' : '?';
      finalPath = '$path${separator}_ts=${DateTime.now().millisecondsSinceEpoch}';
    }
    
    final res = await dio.get(finalPath, options: options);
    
    if (res.statusCode != 200) {
      log.e('GET $path failed with status code ${res.statusCode}');
      throw DioException(requestOptions: res.requestOptions, error: 'GET $path failed with status code ${res.statusCode}');
    }
    
    return res;
  }

// Add more methods for POST, PUT, DELETE as needed
}
