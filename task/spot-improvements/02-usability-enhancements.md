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
