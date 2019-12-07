import '../models/currency.dart';

abstract class CurrenciesDataSource {
  Future<List<Currency>> getCurrencies();
}