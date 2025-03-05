
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:objectbox/objectbox.dart';
import 'package:cnvrt/domain/models/model.dart';

part 'currency.g.dart';

@Entity()
@CopyWith()
class Currency extends Model {
  @Id()
  @override
  int id = 0;

  /*
   * The REPLACE strategy will add a new object with a different ID.
   * As relations (ToOne/ToMany) reference objects by ID, if the previous
   * object was referenced in any relations, these need to be updated manually.
   * https://docs.objectbox.io/entity-annotations#unique-constraints
   */
  @Unique(onConflict: ConflictStrategy.replace)
  final String symbol;
  
  final String name;
  final double rate;
  
  final bool selected;
  int order;

  Currency({
    this.id = 0,
    required this.symbol,
    required this.name,
    required this.rate,
    required this.selected,
    required this.order,
  });

  @override
  String toString() {
    return 'Currency{id: $id, symbol: $symbol, name: $name, rate: $rate, selected: $selected, order: $order}';
  }
  
  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      symbol: json['symbol'],
      name: json['name'],
      rate: (json['rate'] as num).toDouble(),
      selected: false,
      order: 0,
    );
  }
}
