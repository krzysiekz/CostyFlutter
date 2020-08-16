import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/currency.dart';
import '../../repositories/currencies_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class GetCurrencies implements UseCase<List<Currency>, NoParams> {
  final CurrenciesRepository currenciesRepository;

  GetCurrencies({@required this.currenciesRepository});

  @override
  Future<Either<Failure, List<Currency>>> call(NoParams params) {
    return currenciesRepository.getCurrencies();
  }
}
