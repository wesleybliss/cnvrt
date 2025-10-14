import 'package:cnvrt/db/database.dart' as db;
import 'package:cnvrt/domain/io/repos/i_currencies_repo.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spot/spot.dart';

class DebugSqlTestScreen extends ConsumerStatefulWidget {
  const DebugSqlTestScreen({super.key});

  @override
  ConsumerState<DebugSqlTestScreen> createState() => _DebugSqlTestScreenState();
}

class _DebugSqlTestScreenState extends ConsumerState<DebugSqlTestScreen> {
  final log = Logger('DebugSqlTestScreen');
  final currenciesRepo = spot<ICurrenciesRepo>();
  final controller = TextEditingController();

  Future<void> readDatabase() async {
    final List<db.Currency> res = await currenciesRepo.findAll();
    final List<String> data = res.fold([], (acc, it) => acc..add("${it.symbol}: ${it.selected ? "selected" : "ok"}"));
    controller.text = data.join("\n");
  }

  Future<void> writeDatabase() async {
    await currenciesRepo.createFromJson({
      "symbol": "USD",
      "name": "United States Dollar",
      "rate": 1.0,
      "selected": true,
      "order": 0,
    });
    await readDatabase();
  }

  Future<void> updateDatabase() async {
    final currency =
        await (currenciesRepo.db.select(currenciesRepo.db.currencies)
          ..where((t) => t.symbol.equals("USD"))).getSingleOrNull();
    if (currency != null) {
      // await currenciesRepo.update(db.CurrenciesCompanion(selected: drift.Value(!currency.selected)));
      await (currenciesRepo.db.update(
        currenciesRepo.db.currencies,
      )..where((t) => t.symbol.equals("USD"))).write(db.CurrenciesCompanion(selected: drift.Value(!currency.selected)));
    } else {
      log.w("Currency not found");
    }
    await readDatabase();
  }

  Future<void> clearDatabase() async {
    final currencies = await currenciesRepo.findAll();
    for (final currency in currencies) {
      await currenciesRepo.delete(currency);
    }
    await readDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: readDatabase, child: const Text("Read database")),
            ElevatedButton(onPressed: writeDatabase, child: const Text("Write database")),
            ElevatedButton(onPressed: updateDatabase, child: const Text("Update database")),
            ElevatedButton(onPressed: clearDatabase, child: const Text("Clear database")),
            Expanded(child: TextField(controller: controller, readOnly: true, maxLines: 10)),
          ],
        ),
      ),
    );
  }
}
