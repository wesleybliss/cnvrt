import 'package:drift/drift.dart';

class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().nullable().withDefault(currentDateAndTime)();
  TextColumn get symbol => text().customConstraint('UNIQUE')();
  TextColumn get name => text()();
  RealColumn get rate => real()();
  BoolColumn get selected => boolean().clientDefault(() => false)();
  IntColumn get order => integer()();
}
