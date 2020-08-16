import 'package:injectable/injectable.dart';

import '../../../injection.dart';
import '../../models/currency.dart';
import '../currencies_datasource.dart';
import '../entities/currency_entity.dart';
import '../hive_operations.dart';

@Singleton(as: CurrenciesDataSource, env: [Env.prod])
class CurrenciesDataSourceImpl implements CurrenciesDataSource {
  static const _boxName = 'currencies';

  final HiveOperations _hiveOperations;

  CurrenciesDataSourceImpl(this._hiveOperations);

  @override
  Future<List<Currency>> getCurrencies() async {
    final box = await _hiveOperations.openBox(_boxName);
    final entries = box.values;
    final currencyList = entries
        .map((entity) => Currency(name: (entity as CurrencyEntity).name))
        .toList();
    return currencyList;
  }

  @override
  Future<void> saveCurrencies(List<String> currencies) async {
    final box = await _hiveOperations.openBox(_boxName);
    for (final currency in currencies) {
      box.add(CurrencyEntity(name: currency));
    }
  }
}
