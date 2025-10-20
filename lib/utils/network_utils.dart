import 'dart:io';

import 'package:dio/dio.dart';

/// Returns true if the error represents a network connectivity issue
/// (e.g., no internet, DNS failure, connection timeout) rather than
/// an HTTP API error (4xx, 5xx responses).
bool isConnectivityError(Object? error) {
  if (error is DioException) {
    final type = error.type;
    
    // Connection-level failures
    if (type == DioExceptionType.connectionError ||
        type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.badCertificate) {
      return true;
    }
    
    // Check underlying error type
    final innerError = error.error;
    if (innerError is SocketException || innerError is HandshakeException) {
      return true;
    }
    
    // Scan error message for common connectivity patterns
    final message = error.message?.toLowerCase() ?? '';
    final errorString = error.error?.toString().toLowerCase() ?? '';
    final combinedText = '$message $errorString';
    
    const patterns = [
      'socketexception',
      'failed host lookup',
      'connection refused',
      'connection reset',
      'connection closed before',
      'no address associated with hostname',
      'network is unreachable',
      'handshake error',
      'timed out',
      'connection error',
    ];
    
    return patterns.any((pattern) => combinedText.contains(pattern));
  }
  
  return false;
}

/// Returns true if the error represents an HTTP API error response
/// (e.g., 400, 404, 500) rather than a connection issue.
bool isHttpApiError(Object? error) {
  return error is DioException && error.response != null;
}

/// Returns a safe string representation of an error for logging.
/// Truncates very long messages to prevent log spam.
String toStringSafe(Object? error, {int maxLength = 500}) {
  if (error == null) return 'null';
  
  final str = error.toString();
  if (str.length <= maxLength) return str;
  
  return '${str.substring(0, maxLength)}... (truncated)';
}
