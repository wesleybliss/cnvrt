import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/domain/io/repos/i_currencies_repo.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:drift/drift.dart';

class CurrenciesRepo extends ICurrenciesRepo {
  final log = Logger("CurrenciesRepo");

  @override
  Future<Currency> create(Currency currency) async {
    return await db.into(db.currencies).insertReturning(currency.toCompanion(false));
  }

  @override
  Future<Currency> createFromJson(Map<String, dynamic> json) async {
    return create(Currency.fromJson(json));
  }

  @override
  Future<List<Currency>> bulkCreate(List<Currency> currencies) async {
    final List<Currency> createdRows = [];

    for (final it in currencies) {
      final insertedRow = await db.into(db.currencies).insertReturning(it.toCompanion(false));
      createdRows.add(insertedRow);
    }

    return createdRows;
  }

  @override
  Future<List<Currency>> findAll() async {
    return await db.select(db.currencies).get();
  }

  @override
  Future<List<Currency>> findAllOrderedByOrder() async {
    return await (db.select(db.currencies)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.order, mode: OrderingMode.asc)])).get();
  }

  @override
  Future<Currency?> findOneById(int id) async {
    return await (db.select(db.currencies)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<Currency?> findOneBy(Map<String, dynamic> criteria) async {
    final query = db.select(db.currencies);

    // Dynamically build the WHERE clause based on the criteria map
    criteria.forEach((key, value) {
      query.where((tbl) {
        final column = tbl.$columns.firstWhere((col) => col.$name == key);
        return column.equals(value);
      });
    });

    return await query.getSingleOrNull();
  }

  @override
  Future<Currency?> update(Currency currency) async {
    final success = await db.update(db.currencies).replace(currency.toCompanion(false));

    if (success) {
      return await (db.select(db.currencies)..where((tbl) => tbl.id.equals(currency.id))).getSingleOrNull();
    }

    return null;
  }

  @override
  Future<List<Currency>> updateMany(List<Currency> currencies) async {
    return await db.transaction(() async {
      final List<Currency> updatedRows = [];

      for (final currency in currencies) {
        final success = await db.update(db.currencies).replace(currency.toCompanion(false));
        if (success) {
          final updatedRow =
              await (db.select(db.currencies)..where((tbl) => tbl.id.equals(currency.id))).getSingleOrNull();
          if (updatedRow != null) {
            updatedRows.add(updatedRow);
          }
        }
      }

      return updatedRows;
    });
  }

  @override
  Future<Currency> upsert(Currency currency) async {
    final insertedId = await db
        .into(db.currencies)
        .insert(currency.toCompanion(false), mode: InsertMode.insertOrReplace);

    // Fetch the row (whether it was inserted or replaced)
    return await (db.select(db.currencies)..where((tbl) => tbl.id.equals(insertedId ?? currency.id))).getSingle();
  }

  @override
  Future<List<Currency>> upsertMany(List<Currency> currencies) async {
    return await upsertManyCompanions(currencies.map((e) => e.toCompanion(false)).toList());
  }

  @override
  Future<List<Currency>> upsertManyCompanions(List<CurrenciesCompanion> companions) async {
    return await db.transaction(() async {
      final List<Currency> upsertedRows = [];

      for (final companion in companions) {
        log.d("upsertManyCompanions: inserting ${companion.symbol.value}");

        // Use InsertMode.insertOrReplace for upsert behavior
        final insertedId = await db.into(db.currencies).insert(companion, mode: InsertMode.insertOrReplace);

        log.d("upsertManyCompanions: insertedId: $insertedId");

        // Fetch the row (whether it was inserted or replaced)
        final Currency? upsertedRow =
            await (db.select(db.currencies)
              ..where((tbl) => tbl.id.equals(insertedId ?? companion.id.value))).getSingleOrNull();

        log.d("upsertManyCompanions: upsertedRow: ${upsertedRow?.symbol}: ${upsertedRow?.id}");

        if (upsertedRow != null) {
          upsertedRows.add(upsertedRow);
        }
      }

      return upsertedRows;
    });
  }

  @override
  Future<void> delete(Currency currency) async {
    await db.delete(db.currencies).delete(currency);
  }

  @override
  Future<void> deleteById(int id) async {
    await (db.delete(db.currencies)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> deleteAll() async {
    await db.delete(db.currencies).go();
  }
}
