/// Example demonstrating named instances in Spot DI container
/// 
/// Named instances allow registering multiple implementations of the same type,
/// differentiated by an optional name qualifier. This is useful for scenarios like:
/// - Multiple API clients (public, authenticated, admin)
/// - Multiple database connections (production, cache, analytics)
/// - Environment-specific configurations (dev, staging, production)
/// - Feature variants (experimental features)

import 'package:cnvrt/domain/di/spot.dart';

// Example interfaces and implementations

abstract class HttpClient {
  String get baseUrl;
  Future<String> get(String path);
}

class PublicHttpClient implements HttpClient {
  @override
  final String baseUrl = 'https://api.example.com/public';
  
  @override
  Future<String> get(String path) async {
    return 'Public GET: $baseUrl/$path';
  }
}

class AuthenticatedHttpClient implements HttpClient {
  @override
  final String baseUrl = 'https://api.example.com/auth';
  
  @override
  Future<String> get(String path) async {
    return 'Authenticated GET: $baseUrl/$path';
  }
}

class AdminHttpClient implements HttpClient {
  @override
  final String baseUrl = 'https://api.example.com/admin';
  
  @override
  Future<String> get(String path) async {
    return 'Admin GET: $baseUrl/$path';
  }
}

abstract class Database {
  String get name;
  Future<void> connect();
}

class ProductionDatabase implements Database {
  @override
  final String name = 'production';
  
  @override
  Future<void> connect() async {
    print('Connected to production database');
  }
}

class CacheDatabase implements Database {
  @override
  final String name = 'cache';
  
  @override
  Future<void> connect() async {
    print('Connected to cache database');
  }
}

class AnalyticsDatabase implements Database {
  @override
  final String name = 'analytics';
  
  @override
  Future<void> connect() async {
    print('Connected to analytics database');
  }
}

// Example usage
void main() async {
  print('=== Named Instances Example ===\n');
  
  // 1. Register multiple HTTP clients with different names
  print('1. Registering named HTTP clients...');
  Spot.registerSingle<HttpClient, PublicHttpClient>(
    (get) => PublicHttpClient(),
    name: 'public',
  );
  
  Spot.registerSingle<HttpClient, AuthenticatedHttpClient>(
    (get) => AuthenticatedHttpClient(),
    name: 'authenticated',
  );
  
  Spot.registerSingle<HttpClient, AdminHttpClient>(
    (get) => AdminHttpClient(),
    name: 'admin',
  );
  
  // 2. Register named async singletons for databases
  print('2. Registering named async database connections...');
  Spot.registerAsync<Database, ProductionDatabase>(
    (get) async {
      final db = ProductionDatabase();
      await db.connect();
      return db;
    },
    name: 'production',
  );
  
  Spot.registerAsync<Database, CacheDatabase>(
    (get) async {
      final db = CacheDatabase();
      await db.connect();
      return db;
    },
    name: 'cache',
  );
  
  Spot.registerAsync<Database, AnalyticsDatabase>(
    (get) async {
      final db = AnalyticsDatabase();
      await db.connect();
      return db;
    },
    name: 'analytics',
  );
  
  // 3. Register a default (unnamed) instance
  print('3. Registering default (unnamed) HTTP client...');
  Spot.registerSingle<HttpClient, PublicHttpClient>(
    (get) => PublicHttpClient(),
    // No name parameter = default instance
  );
  
  print('\n=== Registry State ===');
  Spot.printRegistry();
  
  // 4. Resolve named instances
  print('\n=== Resolving Named Instances ===\n');
  
  final publicClient = spot<HttpClient>(name: 'public');
  print('Public client base URL: ${publicClient.baseUrl}');
  
  final authClient = spot<HttpClient>(name: 'authenticated');
  print('Auth client base URL: ${authClient.baseUrl}');
  
  final adminClient = spot<HttpClient>(name: 'admin');
  print('Admin client base URL: ${adminClient.baseUrl}');
  
  // 5. Resolve default (unnamed) instance
  print('\n=== Resolving Default Instance ===\n');
  final defaultClient = spot<HttpClient>();  // No name = default
  print('Default client base URL: ${defaultClient.baseUrl}');
  
  // 6. Resolve async named instances
  print('\n=== Resolving Async Named Instances ===\n');
  final prodDb = await spotAsync<Database>(name: 'production');
  print('Connected to database: ${prodDb.name}');
  
  final cacheDb = await spotAsync<Database>(name: 'cache');
  print('Connected to database: ${cacheDb.name}');
  
  final analyticsDb = await spotAsync<Database>(name: 'analytics');
  print('Connected to database: ${analyticsDb.name}');
  
  // 7. Check registration status
  print('\n=== Checking Registration Status ===\n');
  print('Is HttpClient(public) registered? ${Spot.isRegistered<HttpClient>(name: "public")}');
  print('Is HttpClient(private) registered? ${Spot.isRegistered<HttpClient>(name: "private")}');
  print('Is HttpClient (default) registered? ${Spot.isRegistered<HttpClient>()}');
  
  // 8. Factory example with named instances
  print('\n=== Named Factories ===\n');
  
  var requestCount = 0;
  Spot.registerFactory<HttpClient, PublicHttpClient>(
    (get) {
      requestCount++;
      print('Creating factory instance #$requestCount');
      return PublicHttpClient();
    },
    name: 'factory',
  );
  
  final factory1 = spot<HttpClient>(name: 'factory');
  final factory2 = spot<HttpClient>(name: 'factory');
  print('Factory creates new instances: ${factory1 != factory2}');
  
  // 9. Dispose named instances
  print('\n=== Disposing Named Instances ===\n');
  Spot.dispose<HttpClient>(name: 'public');
  print('Disposed HttpClient(public)');
  print('Is HttpClient(public) still registered? ${Spot.isRegistered<HttpClient>(name: "public")}');
  
  // 10. Advanced: Dependencies between named instances
  print('\n=== Dependencies Between Named Instances ===\n');
  
  // Service that depends on a specific named instance
  abstract class ApiService {
    String makeRequest(String path);
  }
  
  class UserApiService implements ApiService {
    final HttpClient client;
    UserApiService(this.client);
    
    @override
    String makeRequest(String path) => 'UserAPI: ${client.baseUrl}/$path';
  }
  
  class AdminApiService implements ApiService {
    final HttpClient client;
    AdminApiService(this.client);
    
    @override
    String makeRequest(String path) => 'AdminAPI: ${client.baseUrl}/$path';
  }
  
  // Register services with dependencies on named instances
  // Note: The get() function currently doesn't support name parameter
  // so we resolve named dependencies directly using spot()
  Spot.registerSingle<ApiService, UserApiService>(
    (get) => UserApiService(spot<HttpClient>(name: 'authenticated')),
    name: 'user',
  );
  
  Spot.registerSingle<ApiService, AdminApiService>(
    (get) => AdminApiService(spot<HttpClient>(name: 'admin')),
    name: 'admin',
  );
  
  final userApi = spot<ApiService>(name: 'user');
  final adminApi = spot<ApiService>(name: 'admin');
  
  print('User API request: ${userApi.makeRequest('profile')}');
  print('Admin API request: ${adminApi.makeRequest('users')}');
  
  print('\n=== Example Complete ===');
}
