import 'package:cnvrt/domain/models/model.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';

late final Store store;

abstract class SimpleCurrencyStore {
  static final log = Logger('SimpleCurrencyStore');

  static Future<void> initializeStore() async {
    /*_objectBox = await ObjectBox._create();
    store = _objectBox.store;*/

    final docsDir = await getApplicationDocumentsDirectory();

    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    store = await openStore(directory: path.join(docsDir.path, "simple-currency-db"));

    /*if (kDebugMode && FeatureFlags.wipeDatabaseOnStart) {
      log.w('***********************************************************************');
      log.w('**** FeatureFlags.wipeDatabaseOnStart set to true, WIPING ALL DATA ****');
      log.w('***********************************************************************');
      spot<AUserDao>().deleteAll(areYouReallySure: true);
      spot<APostDao>().deleteAll(areYouReallySure: true);
    }*/
  }

  static Future<void> updateManyAsync<T>(List<T> fetchedEntities, T Function(T prev) updateFunction) async {
    final box = store.box<T>();
    final existingEntities = box.getAll();

    // Create a map for quick lookup of existing entities by their unique identifier
    // final existingEntityMap = {getEntityKey(existing): existing for existing in existingEntities};
    final Map<int, T> existingEntityMap = {};

    for (var existing in existingEntities) {
      existingEntityMap[getEntityKey(existing)] = existing;
    }

    for (var fetchedEntity in fetchedEntities) {
      final key = getEntityKey(fetchedEntity);

      if (existingEntityMap.containsKey(key)) {
        // Update the existing entity using the provided update function
        var existingEntity = existingEntityMap[key]!;
        var updatedEntity = updateFunction(existingEntity);
        box.put(updatedEntity);
      } else {
        // If it doesn't exist, add it as a new entry
        box.put(fetchedEntity); // This will insert a new entity
      }
    }
  }

  // Function to get the unique key of an entity (you need to implement this based on your entity)
  static int getEntityKey<T>(T entity) {
    return (entity as Model).id; // Assuming 'id' is the unique identifier for Currency
    // Add more cases here for other types as needed
    throw Exception('Unsupported entity type');
  }
}
