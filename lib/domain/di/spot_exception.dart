/// Custom exception for Spot dependency injection framework errors.
///
/// Provides clear, consistent error messages for DI-related issues such as:
/// - Unregistered types
/// - Circular dependencies
/// - Type resolution failures
class SpotException implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// Creates a new [SpotException] with the given [message].
  SpotException(this.message);

  @override
  String toString() => 'SpotException: $message';
}
