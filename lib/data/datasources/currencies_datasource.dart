import '../models/currency.dart';

abstract class CurrenciesDataSource {
  Future<List<Currency>> getCurrencies();

  Future<void> saveCurrencies(List<String> currencies);
}
