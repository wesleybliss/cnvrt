import 'package:drift/drift.dart';

class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().nullable().withDefault(currentDateAndTime)();
  TextColumn get symbol => text()();
  TextColumn get name => text()();
  RealColumn get rate => real()();
  BoolColumn get selected => boolean().clientDefault(() => false)();
  IntColumn get order => integer()();
}

/*class Currency {
  final int id;
  final String createdAt;
  final String symbol;
  final String name;
  final String rate;
  final String selected;
  final String order;

  Currency({
    required this.id,
    required this.createdAt,
    required this.symbol,
    required this.name,
    required this.rate,
    required this.selected,
    required this.order,
  });
}*/
