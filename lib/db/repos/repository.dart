import 'package:cnvrt/config/application.dart';
import 'package:drift/drift.dart';

abstract class Repository<T extends DataClass, C extends Insertable<T>> {
  final db = Application.database;

  Future<T> create(T entity);
  Future<T> createFromJson(Map<String, dynamic> json);
  Future<List<T>> bulkCreate(List<T> entities);

  Future<List<T>> findAll();
  Future<T?> findOneById(int id);
  Future<T?> findOneBy(Map<String, dynamic> criteria);

  Future<T?> update(T entity);
  Future<List<T>> updateMany(List<T> entities);

  Future<T> upsert(T entity);
  Future<List<T>> upsertMany(List<T> entities);
  Future<List<T>> upsertManyCompanions(List<C> companions);

  Future<void> delete(T entity);
  Future<void> deleteById(int id);
  Future<void> deleteAll();
}
