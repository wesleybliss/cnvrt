
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:cnvrt/utils/logger.dart';

abstract class IDioClient {
  
  @protected
  abstract final Logger log;
  
  @protected
  abstract final Dio dio;

  Future<Response> get(String path);
  
}
