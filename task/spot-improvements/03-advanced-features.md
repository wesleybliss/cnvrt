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
