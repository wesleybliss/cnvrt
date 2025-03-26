import 'package:cnvrt/db/database.dart';
import 'package:cnvrt/db/repos/repository.dart';

abstract class ICurrenciesRepo extends Repository<Currency, CurrenciesCompanion> {
  Future<List<Currency>> findAllOrderedByOrder();
}
