import 'package:dartz/dartz.dart';

import '../errors/failures.dart';
import '../models/currency.dart';

abstract class CurrenciesRepository {
  Future<Either<Failure, List<Currency>>> getCurrencies();
}
