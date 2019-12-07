import 'package:dartz/dartz.dart';

import '../../datasources/currencies_datasource.dart';
import '../../errors/failures.dart';
import '../../models/currency.dart';
import '../currencies_repository.dart';

class CurrenciesRepositoryImpl implements CurrenciesRepository {
  final CurrenciesDataSource currenciesDataSource;

  CurrenciesRepositoryImpl(this.currenciesDataSource);

  @override
  Future<Either<Failure, List<Currency>>> getCurrencies() async {
    try {
      final response = await currenciesDataSource.getCurrencies();
      return Right(response);
    } on Exception {
      return Left(DataSourceFailure());
    }
  }
}
