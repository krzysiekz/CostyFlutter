import '../../models/currency.dart';
import '../currencies_datasource.dart';
import '../entities/currency_entity.dart';
import '../hive_operations.dart';

class CurrenciesDataSourceImpl implements CurrenciesDataSource {
  static const _BOX_NAME = 'currencies';

  final HiveOperations hiveOperations;

  CurrenciesDataSourceImpl(this.hiveOperations);

  @override
  Future<List<Currency>> getCurrencies() async {
    var box = await hiveOperations.openBox(_BOX_NAME);
    var currenciesAsMap = box.toMap();
    var currencyEntities = currenciesAsMap.values as Iterable<CurrencyEntity>;
    var currencyList =
        currencyEntities.map((entity) => Currency(name: entity.name)).toList();
    return currencyList;
  }
}
