## 6. Documentation and Developer Experience

### 6.1 Better IntelliSense Documentation

**Recommendation:** Add comprehensive dartdoc comments:

```dart
/// Minimal service locator for dependency injection.
/// 
/// Spot provides a lightweight alternative to more complex DI frameworks,
/// with support for factories and singletons.
/// 
/// ## Registration
/// 
/// Register dependencies during app initialization:
/// ```dart
/// Spot.init((factory, single) {
///   // Singleton (one instance shared across app)
///   single<ISettings, Settings>((get) => Settings());
///   
///   // Factory (new instance on each request)
///   factory<IRepository, Repository>((get) => Repository(get<Database>()));
/// });
/// ```
/// 
/// ## Resolution
/// 
/// Inject dependencies using the `spot<T>()` function:
/// ```dart
/// final settings = spot<ISettings>();
/// ```
/// 
/// ## Testing
/// 
/// Use `SpotTestHelper` to reset and mock dependencies in tests.
abstract class Spot {
  // ...
  
  /// Resolves and returns an instance of type [T].
  /// 
  /// Throws [SpotException] if [T] is not registered.
  /// 
  /// For singletons, returns the same instance on subsequent calls.
  /// For factories, creates a new instance on each call.
  /// 
  /// Example:
  /// ```dart
  /// final settings = Spot.spot<ISettings>();
  /// ```
  static T spot<T>() {
    // ...
  }
  
  /// Registers a factory that creates a new instance on each resolution.
  /// 
  /// [locator] is called each time `spot<T>()` is invoked.
  /// Use [get] parameter to resolve dependencies of [R].
  /// 
  /// Example:
  /// ```dart
  /// Spot.registerFactory<IRepo, Repo>((get) => Repo(get<Database>()));
  /// ```
  static void registerFactory<T, R extends T>(SpotGetter<R> locator) {
    // ...
  }
}
```

**Benefits:**
- Better IDE autocomplete
- Inline documentation
- Examples at point of use
