import 'package:dio/dio.dart';
import 'package:cnvrt/domain/constants/constants.dart';
import 'package:cnvrt/domain/io/net/i_dio_client.dart';
import 'package:cnvrt/utils/logger.dart';

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
    
    final res = await dio.get(path);
    
    if (res.statusCode != 200) {
      log.e('GET $path failed with status code ${res.statusCode}');
      throw DioException(requestOptions: res.requestOptions, error: 'GET $path failed with status code ${res.statusCode}');
    }
    
    return res;
  }

// Add more methods for POST, PUT, DELETE as needed
}
