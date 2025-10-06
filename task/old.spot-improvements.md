# Note: do not use this, it's outdated.

# Task

Spot is a minimal dependency injection (DI) framework implemented in Dart.
Actually, it's more of a service locator pattern than a full DI framework.
While it serves basic DI needs, there are several areas where it could be improved
to enhance usability, performance, and maintainability.

The goal of this task is to implement the suggestions below to make Spot a more robust,
but maintain it's lightweight nature and simplicity.

The long term goal will be to break Spot out into its own package, so it can be reused
across multiple projects. But first, we want to ensure it's solid and production-ready
by using it within this project.

Implement the suggestions below as you see fit, one at a time, and stop to ask before starting the next.
Keep a running list of changes made and why, so we can document them later.
Keep the checklist below up to date as you progress.
Each suggestion should be done in it's own git branch, with a descriptive commit message.

# Checklist


# Suggestions

## Overview

The Spot DI framework is a lightweight, minimal service locator implementation that serves the app well for basic dependency injection needs. However, there are several areas where improvements could enhance performance, type safety, developer experience, and maintainability. The suggestions below are organized by priority and category.

---

## 1. Critical Improvements

### 1.1 Thread Safety for Singleton Initialization

**Issue:** The current singleton instantiation is not thread-safe. Multiple threads could simultaneously check `instance == null` and create multiple instances.

**Current Implementation:**
```dart
T locate() {
  if (type == SpotType.factory) {
    return locator(_spot);
  }

  instance ??= locator(_spot);  // Not thread-safe!
  return instance!;
}
```

**Recommended Fix:** Add synchronization using a mutex or lock:

```dart
import 'package:synchronized/synchronized.dart';

class SpotService<T> {
  final SpotType type;
  final SpotGetter<T> locator;
  final Type targetType;
  final _lock = Lock();  // Add lock for thread safety
  
  T? instance;

  SpotService(this.type, this.locator, this.targetType);

  R _spot<R>() => Spot.spot<R>();

  T locate() {
    if (type == SpotType.factory) {
      return locator(_spot);
    }

    // Thread-safe singleton initialization
    if (instance != null) return instance!;
    
    return _lock.synchronized(() {
      instance ??= locator(_spot);
      return instance!;
    });
  }

  void dispose() {
    instance = null;
  }
}
```

**Benefits:**
- Prevents race conditions in multi-threaded scenarios
- Ensures true singleton behavior
- Minimal performance impact (lock only held during first initialization)

**Dependencies:** Add `synchronized: ^3.1.0+1` to `pubspec.yaml`

---

### 1.2 Circular Dependency Detection

**Issue:** No protection against circular dependencies, which can cause stack overflow errors that are difficult to debug.

**Example Problem:**
```dart
Spot.init((factory, single) {
  single<ServiceA>((get) => ServiceA(get<ServiceB>()));
  single<ServiceB>((get) => ServiceB(get<ServiceA>()));  // Circular!
});
```

**Recommended Fix:** Track dependency resolution stack:

```dart
abstract class Spot {
  static final log = Logger('Spot');
  static bool logging = false;
  static final registry = <Type, SpotService>{};
  
  // Track current resolution stack to detect circular dependencies
  static final _resolutionStack = <Type>[];

  static T spot<T>() {
    if (!registry.containsKey(T)) {
      throw SpotException('Class $T is not registered');
    }

    // Check for circular dependency
    if (_resolutionStack.contains(T)) {
      final cycle = [..._resolutionStack, T].map((t) => t.toString()).join(' -> ');
      throw SpotException(
        'Circular dependency detected: $cycle\n'
        'Cannot resolve $T because it depends on itself (directly or indirectly).'
      );
    }

    _resolutionStack.add(T);
    
    try {
      if (logging) log.v('Injecting $T -> ${registry[T]!.targetType}');
      
      final instance = registry[T]!.locate();
      if (instance == null) {
        throw SpotException('Class $T is not registered');
      }
      
      return instance;
    } catch (e) {
      log.e('Failed to locate class $T', e);
      rethrow;
    } finally {
      _resolutionStack.removeLast();
    }
  }
  
  // ... rest of implementation
}

// Custom exception for better error handling
class SpotException implements Exception {
  final String message;
  SpotException(this.message);
  
  @override
  String toString() => 'SpotException: $message';
}
```

**Benefits:**
- Prevents infinite recursion and stack overflow
- Provides clear error messages showing the dependency cycle
- Helps developers identify and fix circular dependencies quickly

---

## 2. Usability Enhancements

### 2.1 Improved Error Messages and Debugging

**Issue:** Current error messages are generic and don't provide helpful context.

**Current:**
```dart
throw Exception('Spot: Class $T is not registered');
```

**Recommended Improvement:**

```dart
abstract class Spot {
  // ... existing code ...
  
  static T spot<T>() {
    if (!registry.containsKey(T)) {
      final registeredTypes = registry.keys.map((t) => t.toString()).join(', ');
      throw SpotException(
        'Type $T is not registered in Spot container.\n'
        'Registered types: $registeredTypes\n\n'
        'Did you forget to register it in SpotModule.registerDependencies()?\n'
        'Example: single<$T, ConcreteType>((get) => ConcreteType());'
      );
    }
    // ... rest of implementation
  }
  
  // Add method to inspect registered dependencies
  static void printRegistry() {
    log.i('=== Spot Registry (${registry.length} types) ===');
    for (var entry in registry.entries) {
      final service = entry.value;
      final typeStr = service.type == SpotType.singleton ? 'singleton' : 'factory';
      final hasInstance = service.instance != null ? '(initialized)' : '';
      log.i('  ${entry.key} -> ${service.targetType} [$typeStr] $hasInstance');
    }
    log.i('=' * 50);
  }
  
  // Check if a type is registered without throwing
  static bool isRegistered<T>() => registry.containsKey(T);
}
```

**Benefits:**
- Developers can quickly see what went wrong
- Suggests the fix directly in the error message
- Easy to debug registration issues

---

### 2.2 Asynchronous Initialization Support

**Issue:** Many services require async initialization (database connections, API clients with tokens, etc.), but Spot doesn't support async factories.

**Current Workaround:**
```dart
// Must initialize elsewhere and inject already-initialized instance
final client = await ApiClient.initialize();
Spot.registerSingle<ApiClient>((get) => client);
```

**Recommended Enhancement:**

```dart
typedef SpotAsyncGetter<T> = Future<T> Function(Function<R>() get);

enum SpotType {
  factory,
  singleton,
  asyncSingleton,  // New type
}

class SpotService<T> {
  final SpotType type;
  final SpotGetter<T>? locator;
  final SpotAsyncGetter<T>? asyncLocator;  // New field
  final Type targetType;
  final _lock = Lock();
  
  T? instance;
  Future<T>? _initializationFuture;  // Track async initialization

  SpotService(this.type, this.locator, this.targetType, {this.asyncLocator});

  R _spot<R>() => Spot.spot<R>();

  T locate() {
    if (type == SpotType.asyncSingleton) {
      throw SpotException(
        'Cannot synchronously resolve async singleton $T. '
        'Use await Spot.spotAsync<$T>() instead.'
      );
    }
    
    if (type == SpotType.factory) {
      return locator!(_spot);
    }

    if (instance != null) return instance!;
    
    return _lock.synchronized(() {
      instance ??= locator!(_spot);
      return instance!;
    });
  }
  
  Future<T> locateAsync() async {
    if (type == SpotType.factory) {
      return locator!(_spot);
    }
    
    if (type == SpotType.singleton) {
      return locate();  // Delegate to sync method
    }
    
    // Async singleton
    if (instance != null) return instance!;
    
    return await _lock.synchronized(() async {
      // Check again inside lock
      if (instance != null) return instance!;
      
      // If already initializing, wait for that
      if (_initializationFuture != null) {
        return await _initializationFuture!;
      }
      
      // Start initialization
      _initializationFuture = asyncLocator!(_spot);
      instance = await _initializationFuture!;
      _initializationFuture = null;
      
      return instance!;
    });
  }

  void dispose() {
    instance = null;
    _initializationFuture = null;
  }
}

abstract class Spot {
  // ... existing code ...
  
  // Register async singleton
  static void registerAsync<T, R>(SpotAsyncGetter<T> locator) {
    if (registry.containsKey(T) && logging) {
      log.w('Overriding async singleton: $T');
    }

    registry[T] = SpotService(
      SpotType.asyncSingleton, 
      null, 
      R,
      asyncLocator: locator,
    );

    if (logging) log.v('Registered async singleton $T');
  }
  
  // Async resolution
  static Future<T> spotAsync<T>() async {
    if (!registry.containsKey(T)) {
      throw SpotException('Class $T is not registered');
    }

    if (logging) log.v('Async injecting $T -> ${registry[T]!.targetType}');

    try {
      final instance = await registry[T]!.locateAsync();
      if (instance == null) {
        throw SpotException('Class $T resolved to null');
      }
      return instance;
    } catch (e) {
      log.e('Failed to async locate class $T', e);
      rethrow;
    }
  }
}

// Usage example:
Spot.init((factory, single) {
  // Sync dependencies
  single<Dio>((get) => Dio());
  
  // Async dependencies (not available in current init signature)
});

// Register async separately
Spot.registerAsync<Database, AppDatabase>((get) async {
  final db = AppDatabase();
  await db.initialize();
  return db;
});

// Resolve async
final db = await Spot.spotAsync<Database>();
```

**Benefits:**
- Proper support for async initialization patterns
- Thread-safe async singleton initialization
- Prevents multiple concurrent initializations
- Clear error messages when mixing sync/async access

---

### 2.3 Type-Safe Registration with Validation

**Issue:** The current implementation uses type parameters but doesn't enforce that the registered type actually implements/extends the interface.

**Current:**
```dart
// This compiles but is wrong:
Spot.registerSingle<ISettings, DioClient>((get) => DioClient());
// DioClient doesn't implement ISettings!
```

**Recommended Improvement:**

```dart
abstract class Spot {
  // ... existing code ...
  
  static void registerFactory<T, R extends T>(SpotGetter<R> locator) {
    if (registry.containsKey(T) && logging) {
      log.w('Overriding factory: $T with $R');
    }

    registry[T] = SpotService<T>(SpotType.factory, locator as SpotGetter<T>, R);

    if (logging) log.v('Registered factory $T -> $R');
  }

  static void registerSingle<T, R extends T>(SpotGetter<R> locator) {
    if (registry.containsKey(T) && logging) {
      log.w('Overriding single: $T with $R');
    }

    registry[T] = SpotService<T>(SpotType.singleton, locator as SpotGetter<T>, R);

    if (logging) log.v('Registered singleton $T -> $R');
  }
}
```

The change: `R` becomes `R extends T` to enforce that the concrete type extends/implements the interface type.

**Benefits:**
- Compile-time type safety
- Prevents registration mistakes
- Better IDE autocomplete and error detection

---

## 3. Advanced Features

### 3.1 Lifecycle Hooks and Disposable Support

**Issue:** No built-in support for cleaning up resources when singletons are disposed.

**Recommended Enhancement:**

```dart
// Define disposable interface
abstract class Disposable {
  void dispose();
}

class SpotService<T> {
  final SpotType type;
  final SpotGetter<T> locator;
  final Type targetType;
  final _lock = Lock();
  
  T? instance;

  SpotService(this.type, this.locator, this.targetType);

  R _spot<R>() => Spot.spot<R>();

  T locate() {
    if (type == SpotType.factory) {
      return locator(_spot);
    }

    if (instance != null) return instance!;
    
    return _lock.synchronized(() {
      instance ??= locator(_spot);
      return instance!;
    });
  }

  void dispose() {
    // Call dispose on instance if it implements Disposable
    if (instance is Disposable) {
      (instance as Disposable).dispose();
    }
    instance = null;
  }
}

abstract class Spot {
  // ... existing code ...
  
  static void dispose<T>() {
    if (registry.containsKey(T)) {
      final service = registry[T];
      service?.dispose();  // Calls Disposable.dispose() if applicable
      registry.remove(T);
      if (logging) log.v('Disposed $T');
    }
  }

  static void disposeAll() {
    if (logging) log.i('Disposing all registered services...');
    
    for (var entry in registry.entries) {
      entry.value.dispose();
    }
    
    registry.clear();
    if (logging) log.i('All services disposed');
  }
}

// Usage example:
class ApiClient implements Disposable {
  final Dio dio;
  
  ApiClient(this.dio);
  
  @override
  void dispose() {
    dio.close();
    print('ApiClient cleaned up');
  }
}
```

**Benefits:**
- Automatic cleanup of resources (database connections, HTTP clients, etc.)
- Prevents memory leaks
- Clean shutdown process

---

### 3.2 Named Instances / Qualifiers

**Issue:** Cannot register multiple implementations of the same interface.

**Example Need:**
```dart
// Want to register both:
Spot.registerSingle<HttpClient>(...)  // Public client
Spot.registerSingle<HttpClient>(...)  // Authenticated client
```

**Recommended Enhancement:**

```dart
class SpotKey<T> {
  final Type type;
  final String? name;
  
  const SpotKey(this.type, [this.name]);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpotKey &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          name == other.name;

  @override
  int get hashCode => type.hashCode ^ (name?.hashCode ?? 0);
  
  @override
  String toString() => name != null ? '$type($name)' : '$type';
}

abstract class Spot {
  static final log = Logger('Spot');
  static bool logging = false;
  
  // Change registry to use SpotKey instead of Type
  static final registry = <SpotKey, SpotService>{};

  static bool get isEmpty => registry.isEmpty;

  static void registerFactory<T, R extends T>(
    SpotGetter<R> locator, {
    String? name,
  }) {
    final key = SpotKey<T>(T, name);
    
    if (registry.containsKey(key) && logging) {
      log.w('Overriding factory: $key');
    }

    registry[key] = SpotService<T>(SpotType.factory, locator as SpotGetter<T>, R);

    if (logging) log.v('Registered factory $key -> $R');
  }

  static void registerSingle<T, R extends T>(
    SpotGetter<R> locator, {
    String? name,
  }) {
    final key = SpotKey<T>(T, name);
    
    if (registry.containsKey(key) && logging) {
      log.w('Overriding single: $key');
    }

    registry[key] = SpotService<T>(SpotType.singleton, locator as SpotGetter<T>, R);

    if (logging) log.v('Registered singleton $key -> $R');
  }

  static T spot<T>({String? name}) {
    final key = SpotKey<T>(T, name);
    
    if (!registry.containsKey(key)) {
      throw SpotException('$key is not registered');
    }

    if (logging) log.v('Injecting $key -> ${registry[key]!.targetType}');

    try {
      final instance = registry[key]!.locate();
      if (instance == null) {
        throw SpotException('$key resolved to null');
      }
      return instance;
    } catch (e) {
      log.e('Failed to locate $key', e);
      rethrow;
    }
  }
  
  // ... rest of methods updated similarly ...
}

// Usage:
Spot.init((factory, single) {
  single<HttpClient, HttpClient>(
    (get) => HttpClient(baseUrl: 'https://api.public.com'),
    name: 'public',
  );
  
  single<HttpClient, HttpClient>(
    (get) => HttpClient(
      baseUrl: 'https://api.private.com',
      token: get<IAuth>().token,
    ),
    name: 'authenticated',
  );
});

// Retrieve named instances:
final publicClient = spot<HttpClient>(name: 'public');
final authClient = spot<HttpClient>(name: 'authenticated');
```

**Benefits:**
- Support for multiple implementations of the same interface
- More flexible dependency configuration
- Useful for feature flags, environment-specific configs, etc.

---

### 3.3 Scoped Containers (Child Scopes)

**Issue:** All dependencies are global. No way to create isolated scopes for tests or features.

**Recommended Enhancement:**

```dart
class SpotContainer {
  final SpotContainer? parent;
  final registry = <Type, SpotService>{};
  bool logging = false;
  
  SpotContainer({this.parent});
  
  void registerFactory<T, R extends T>(SpotGetter<R> locator) {
    registry[T] = SpotService<T>(SpotType.factory, locator as SpotGetter<T>, R);
  }

  void registerSingle<T, R extends T>(SpotGetter<R> locator) {
    registry[T] = SpotService<T>(SpotType.singleton, locator as SpotGetter<T>, R);
  }
  
  T spot<T>() {
    // Check this container first
    if (registry.containsKey(T)) {
      return registry[T]!.locate();
    }
    
    // Fall back to parent
    if (parent != null) {
      return parent!.spot<T>();
    }
    
    throw SpotException('$T not registered in this scope or parent scopes');
  }
  
  void dispose() {
    for (var service in registry.values) {
      service.dispose();
    }
    registry.clear();
  }
  
  SpotContainer createChild() {
    return SpotContainer(parent: this);
  }
}

abstract class Spot {
  static late SpotContainer _globalContainer;
  
  static void initialize() {
    _globalContainer = SpotContainer();
  }
  
  // Delegate to global container
  static void registerFactory<T, R extends T>(SpotGetter<R> locator) {
    _globalContainer.registerFactory<T, R>(locator);
  }

  static void registerSingle<T, R extends T>(SpotGetter<R> locator) {
    _globalContainer.registerSingle<T, R>(locator);
  }
  
  static T spot<T>() {
    return _globalContainer.spot<T>();
  }
  
  // Create isolated scope
  static SpotContainer createScope() {
    return _globalContainer.createChild();
  }
}

// Usage:
// Global dependencies
Spot.registerSingle<ApiClient>((get) => ApiClient());

// Create a test scope
final testScope = Spot.createScope();
testScope.registerSingle<ApiClient, MockApiClient>((get) => MockApiClient());

// Test code uses testScope.spot<ApiClient>() and gets mock
// App code uses Spot.spot<ApiClient>() and gets real implementation
```

**Benefits:**
- Isolated dependency scopes for testing
- Feature-specific dependency trees
- Override dependencies without affecting global state

---

## 4. Testing Support

### 4.1 Enhanced Test Utilities

**Current State:** Basic test helper exists but could be more comprehensive.

**Recommended Enhancements:**

```dart
class SpotTestHelper {
  static final _originalRegistry = <Type, SpotService>{};
  
  /// Save current registry state
  static void saveState() {
    _originalRegistry.clear();
    _originalRegistry.addAll(Spot.registry);
  }
  
  /// Restore saved registry state
  static void restoreState() {
    Spot.registry.clear();
    Spot.registry.addAll(_originalRegistry);
    _originalRegistry.clear();
  }
  
  /// Reset DI container
  static void resetDI() {
    Spot.disposeAll();
  }
  
  /// Register a mock for testing
  static void registerMock<T>(T mock) {
    Spot.registerSingle<T, T>((get) => mock);
  }
  
  /// Run test with isolated DI state
  static Future<void> runIsolated(Future<void> Function() testFn) async {
    saveState();
    try {
      await testFn();
    } finally {
      restoreState();
    }
  }
  
  /// Verify a dependency is registered
  static bool isRegistered<T>() {
    return Spot.isRegistered<T>();
  }
  
  /// Get registration info for debugging
  static String getRegistrationInfo<T>() {
    if (!Spot.registry.containsKey(T)) {
      return '$T: NOT REGISTERED';
    }
    
    final service = Spot.registry[T]!;
    final typeStr = service.type == SpotType.singleton ? 'singleton' : 'factory';
    final hasInstance = service.instance != null;
    return '$T -> ${service.targetType} [$typeStr] ${hasInstance ? "(initialized)" : "(not initialized)"}';
  }
}

// Usage in tests:
test('currency conversion works correctly', () async {
  await SpotTestHelper.runIsolated(() async {
    // Register mocks for this test only
    SpotTestHelper.registerMock<ISettings>(MockSettings(
      roundingDecimals: 2,
      accountForInflation: false,
    ));
    
    // Test code here
    final result = convertCurrencies('USD', 100, currencies);
    expect(result['EUR'], closeTo(85.0, 0.1));
  });
  // Original DI state is restored automatically
});
```

**Benefits:**
- Easy mock registration
- Isolated test state
- Automatic cleanup
- Better debugging tools

---

## 5. Performance Optimizations

### 5.1 Registry Lookup Optimization

**Issue:** Every call to `spot<T>()` performs multiple map lookups and type checks.

**Recommended Optimization:**

```dart
abstract class Spot {
  static final registry = <Type, SpotService>{};
  
  // Cache frequently accessed singletons
  static final _singletonCache = <Type, dynamic>{};
  
  static T spot<T>() {
    // Fast path: check singleton cache first
    if (_singletonCache.containsKey(T)) {
      return _singletonCache[T] as T;
    }
    
    final service = registry[T];
    if (service == null) {
      throw SpotException('$T is not registered');
    }

    if (logging) log.v('Injecting $T -> ${service.targetType}');

    try {
      final instance = service.locate();
      if (instance == null) {
        throw SpotException('$T resolved to null');
      }
      
      // Cache initialized singletons
      if (service.type == SpotType.singleton) {
        _singletonCache[T] = instance;
      }
      
      return instance;
    } catch (e) {
      log.e('Failed to locate $T', e);
      rethrow;
    }
  }
  
  static void dispose<T>() {
    if (registry.containsKey(T)) {
      registry[T]?.dispose();
      registry.remove(T);
      _singletonCache.remove(T);  // Clear cache
    }
  }

  static void disposeAll() {
    registry.clear();
    _singletonCache.clear();
  }
}
```

**Benefits:**
- Faster repeated access to singletons
- Reduced map lookup overhead
- Still maintains lazy initialization

---

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

---

## 7. Migration Path

If implementing these suggestions, consider a phased approach:

### Phase 1: Critical Fixes (Week 1)
- Thread safety for singletons
- Circular dependency detection
- Improved error messages

### Phase 2: Usability (Week 2-3)
- Type-safe registration with `R extends T`
- Better logging and registry inspection
- Enhanced test utilities

### Phase 3: Advanced Features (Week 4+)
- Async initialization support
- Named instances/qualifiers
- Lifecycle hooks and Disposable support

### Phase 4: Optional Enhancements (Future)
- Scoped containers
- Performance optimizations
- Comprehensive documentation

---

## 8. Alternative: Consider Existing Solutions

### When to Keep Spot:
- You value minimal dependencies
- The codebase is small to medium
- Current functionality meets 90% of needs
- Team prefers owning the code

### When to Migrate to GetIt:
- Need production-tested DI solution
- Want advanced features without implementation cost
- Team is growing and needs standard patterns
- Require features like modules, async support, etc.

GetIt provides:
- Thread-safe singleton initialization
- Async registration and resolution
- Named instances
- Scopes
- Environment-specific registration
- Disposal management
- Comprehensive error messages
- Well-documented and widely used

```dart
// GetIt equivalent to Spot:
final getIt = GetIt.instance;

// Registration
getIt.registerSingleton<ISettings>(Settings());
getIt.registerFactory<IRepo>(() => Repo(getIt<Database>()));

// Resolution
final settings = getIt<ISettings>();
```

---

## Summary

The Spot DI framework is elegant and minimal, which is valuable. The suggested improvements fall into three tiers:

**Must-Have (Production Safety):**
1. Thread-safe singleton initialization
2. Circular dependency detection
3. Better error messages

**Should-Have (Developer Experience):**
4. Type-safe registration (`R extends T`)
5. Async initialization support
6. Enhanced test utilities
7. Disposable lifecycle hooks

**Nice-to-Have (Advanced Use Cases):**
8. Named instances/qualifiers
9. Scoped containers
10. Performance optimizations
11. Comprehensive documentation

Implementing even just the "Must-Have" improvements would significantly increase the robustness and maintainability of the Spot framework while preserving its lightweight philosophy.
