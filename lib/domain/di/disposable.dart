/// Interface for objects that require cleanup when disposed.
///
/// Implement this interface for services that need to release resources
/// such as database connections, HTTP clients, file handles, or subscriptions.
///
/// When a singleton service implementing [Disposable] is disposed via
/// [Spot.dispose] or [Spot.disposeAll], its [dispose] method will be
/// automatically called before the instance is cleared from the registry.
///
/// Example:
/// ```dart
/// class ApiClient implements Disposable {
///   final Dio dio;
///
///   ApiClient(this.dio);
///
///   @override
///   void dispose() {
///     dio.close();
///     print('ApiClient cleaned up');
///   }
/// }
/// ```
abstract class Disposable {
  /// Release resources held by this object.
  ///
  /// This method is called automatically when the service is disposed
  /// from the Spot DI container. Override this method to clean up
  /// resources such as:
  /// - Closing database connections
  /// - Cancelling HTTP requests
  /// - Closing file handles
  /// - Disposing streams and subscriptions
  /// - Releasing native resources
  void dispose();
}
