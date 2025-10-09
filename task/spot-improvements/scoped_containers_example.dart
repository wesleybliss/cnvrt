/// Example demonstrating scoped containers in Spot DI framework
/// 
/// Scoped containers allow creating isolated dependency scopes that:
/// - Inherit from parent scopes (including global)
/// - Can override dependencies without affecting parents
/// - Support nested hierarchies
/// - Can be disposed independently
/// 
/// Use cases:
/// - Test isolation (override dependencies per test)
/// - Feature modules (feature-specific dependencies)
/// - Request-scoped dependencies (web request handlers)
/// - Temporary state that needs cleanup

import 'package:cnvrt/domain/di/spot.dart';

// Example interfaces and implementations

abstract class ILogger {
  void log(String message);
}

class ProductionLogger implements ILogger {
  @override
  void log(String message) => print('[PRODUCTION] $message');
}

class TestLogger implements ILogger {
  @override
  void log(String message) => print('[TEST] $message');
}

class DebugLogger implements ILogger {
  @override
  void log(String message) => print('[DEBUG] $message');
}

abstract class IApiClient {
  String get baseUrl;
  Future<String> request(String endpoint);
}

class ProductionApiClient implements IApiClient {
  @override
  final String baseUrl = 'https://api.production.com';
  
  @override
  Future<String> request(String endpoint) async {
    return 'Production API: $baseUrl/$endpoint';
  }
}

class MockApiClient implements IApiClient {
  @override
  final String baseUrl = 'https://api.mock.com';
  
  @override
  Future<String> request(String endpoint) async {
    return 'Mock API: $baseUrl/$endpoint';
  }
}

abstract class IDatabase {
  String get connectionString;
  Future<void> connect();
}

class ProductionDatabase implements IDatabase {
  @override
  final String connectionString = 'prod-db:5432';
  
  @override
  Future<void> connect() async {
    print('Connected to $connectionString');
  }
}

class TestDatabase implements IDatabase {
  @override
  final String connectionString = 'test-db:5432';
  
  @override
  Future<void> connect() async {
    print('Connected to $connectionString');
  }
}

class UserService {
  final IApiClient apiClient;
  final ILogger logger;
  
  UserService(this.apiClient, this.logger);
  
  Future<String> getUser(int id) async {
    logger.log('Fetching user $id');
    return await apiClient.request('users/$id');
  }
}

void main() async {
  print('=== Scoped Containers Example ===\n');
  
  // 1. Register global dependencies
  print('1. Registering global dependencies...');
  Spot.registerSingle<ILogger, ProductionLogger>(
    (get) => ProductionLogger(),
  );
  
  Spot.registerSingle<IApiClient, ProductionApiClient>(
    (get) => ProductionApiClient(),
  );
  
  Spot.registerAsync<IDatabase, ProductionDatabase>(
    (get) async {
      final db = ProductionDatabase();
      await db.connect();
      return db;
    },
  );
  
  // 2. Use global dependencies
  print('\n2. Using global dependencies:');
  final prodLogger = spot<ILogger>();
  prodLogger.log('Application started');
  
  final prodApi = spot<IApiClient>();
  print('Global API base URL: ${prodApi.baseUrl}');
  
  final prodDb = await spotAsync<IDatabase>();
  print('Global DB connection: ${prodDb.connectionString}');
  
  // 3. Create a test scope that overrides some dependencies
  print('\n3. Creating test scope with overrides:');
  final testScope = Spot.createScope();
  
  testScope.registerSingle<ILogger, TestLogger>(
    (get) => TestLogger(),
  );
  
  testScope.registerSingle<IApiClient, MockApiClient>(
    (get) => MockApiClient(),
  );
  
  // Database is not overridden, should fall back to global
  
  // 4. Use test scope
  print('\n4. Using test scope:');
  final testLogger = testScope.spot<ILogger>();
  testLogger.log('Test started');
  
  final testApi = testScope.spot<IApiClient>();
  print('Test API base URL: ${testApi.baseUrl}');
  
  // Falls back to global
  final testDb = await testScope.spotAsync<IDatabase>();
  print('Test DB connection (inherited from global): ${testDb.connectionString}');
  
  // 5. Verify global scope is unchanged
  print('\n5. Verifying global scope unchanged:');
  final stillProdLogger = spot<ILogger>();
  stillProdLogger.log('Still using production logger');
  
  // 6. Create nested scope (child of test scope)
  print('\n6. Creating nested scope:');
  final nestedScope = testScope.createChild();
  
  nestedScope.registerSingle<ILogger, DebugLogger>(
    (get) => DebugLogger(),
  );
  
  // API is not overridden in nested scope, falls back to test scope
  // Logger is overridden in nested scope
  
  print('\n7. Using nested scope:');
  final nestedLogger = nestedScope.spot<ILogger>();
  nestedLogger.log('Using nested logger');
  
  // Falls back to testScope's MockApiClient
  final nestedApi = nestedScope.spot<IApiClient>();
  print('Nested API base URL (inherited from test scope): ${nestedApi.baseUrl}');
  
  // Falls back through testScope to global
  final nestedDb = await nestedScope.spotAsync<IDatabase>();
  print('Nested DB connection (inherited from global): ${nestedDb.connectionString}');
  
  // 8. Demonstrate hierarchy fallback
  print('\n8. Scope hierarchy demonstration:');
  print('   Global -> TestScope -> NestedScope');
  print('   ILogger: Production -> Test -> Debug');
  print('   IApiClient: Production -> Mock -> (inherits Mock)');
  print('   IDatabase: Production -> (inherits) -> (inherits)');
  
  // 9. Dependency resolution with scoped services
  print('\n9. Service with dependencies in different scopes:');
  
  // Register UserService in nested scope that depends on scoped dependencies
  nestedScope.registerSingle<UserService, UserService>(
    (get) => UserService(
      nestedScope.spot<IApiClient>(),
      nestedScope.spot<ILogger>(),
    ),
  );
  
  final userService = nestedScope.spot<UserService>();
  final result = await userService.getUser(123);
  print('User service result: $result');
  
  // 10. Check registration status across scopes
  print('\n10. Registration status across scopes:');
  print('Is ILogger registered in global? ${Spot.isRegistered<ILogger>()}');
  print('Is ILogger registered in test scope? ${testScope.isRegistered<ILogger>()}');
  print('Is ILogger registered in nested scope? ${nestedScope.isRegistered<ILogger>()}');
  print('Is UserService registered in global? ${Spot.isRegistered<UserService>()}');
  print('Is UserService registered in test scope? ${testScope.isRegistered<UserService>()}');
  print('Is UserService registered in nested scope? ${nestedScope.isRegistered<UserService>()}');
  
  // 11. Dispose nested scope (doesn't affect test scope or global)
  print('\n11. Disposing nested scope:');
  nestedScope.dispose();
  print('Nested scope disposed');
  
  // Verify test scope still works
  print('\n12. Verifying test scope still works after nested disposal:');
  final stillTestApi = testScope.spot<IApiClient>();
  print('Test scope API still works: ${stillTestApi.baseUrl}');
  
  // 13. Dispose test scope (doesn't affect global)
  print('\n13. Disposing test scope:');
  testScope.dispose();
  print('Test scope disposed');
  
  // Verify global scope still works
  print('\n14. Verifying global scope still works:');
  final stillGlobalLogger = spot<ILogger>();
  stillGlobalLogger.log('Global scope still works after all disposals');
  
  // 15. Multiple independent scopes
  print('\n15. Creating multiple independent scopes:');
  final scope1 = Spot.createScope();
  scope1.registerSingle<ILogger, TestLogger>((get) => TestLogger());
  
  final scope2 = Spot.createScope();
  scope2.registerSingle<ILogger, DebugLogger>((get) => DebugLogger());
  
  final logger1 = scope1.spot<ILogger>();
  final logger2 = scope2.spot<ILogger>();
  
  logger1.log('From scope 1');
  logger2.log('From scope 2');
  
  // 16. Cleanup
  print('\n16. Cleaning up all scopes:');
  scope1.dispose();
  scope2.dispose();
  print('All scopes disposed');
  
  // Global still intact
  final finalLogger = spot<ILogger>();
  finalLogger.log('Application still running with global dependencies');
  
  print('\n=== Example Complete ===');
  print('\nKey Takeaways:');
  print('- Scoped containers inherit from parents');
  print('- Local registrations shadow parent registrations');
  print('- Disposing a scope doesn\'t affect parent or siblings');
  print('- Nested scopes can create deep hierarchies');
  print('- Perfect for test isolation and feature modules');
}
