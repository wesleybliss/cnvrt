import 'dart:io';

import 'package:cnvrt/utils/network_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isConnectivityError', () {
    test('returns true for connection timeout', () {
      final e = DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionTimeout);
      expect(isConnectivityError(e), isTrue);
    });

    test('returns true for SocketException', () {
      final e = DioException(requestOptions: RequestOptions(), error: const SocketException('Failed host lookup'));
      expect(isConnectivityError(e), isTrue);
    });

    test('returns true for typical message substrings', () {
      final e = DioException(requestOptions: RequestOptions(), message: 'Connection refused');
      expect(isConnectivityError(e), isTrue);
    });

    test('returns false for HTTP 500 response', () {
      final e = DioException(requestOptions: RequestOptions(), response: Response(requestOptions: RequestOptions(), statusCode: 500));
      expect(isConnectivityError(e), isFalse);
    });
  });
}
