import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'currency_entity.g.dart';

@HiveType()
class CurrencyEntity {
  
  @HiveField(0)
  final String name;

  CurrencyEntity({@required this.name});
}
