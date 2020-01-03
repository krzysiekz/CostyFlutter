import '../../models/currency.dart';
import '../currencies_datasource.dart';
import '../entities/currency_entity.dart';
import '../hive_operations.dart';

class CurrenciesDataSourceImpl implements CurrenciesDataSource {
  static const _BOX_NAME = 'currencies';

  final HiveOperations _hiveOperations;

  CurrenciesDataSourceImpl(this._hiveOperations);

  @override
  Future<List<Currency>> getCurrencies() async {
    var box = await _hiveOperations.openBox(_BOX_NAME);
    var entries = box.values;
    var currencyList =
        entries.map((entity) => Currency(name: entity.name)).toList();
    return currencyList;
  }

  @override
  Future<void> saveCurrencies(List<String> currencies) async {
    var box = await _hiveOperations.openBox(_BOX_NAME);
    currencies.forEach(
        (currency) async => await box.add(CurrencyEntity(name: currency)));
  }
}
