import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import './bloc.dart';
import '../../data/errors/failures.dart';
import '../../data/models/currency.dart';
import '../../data/usecases/impl/get_currencies.dart';
import '../../data/usecases/usecase.dart';
import '../../injection.dart';

@Singleton(env: [Env.prod])
class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetCurrencies getCurrencies;

  CurrencyBloc(this.getCurrencies) : super(CurrencyEmpty());

  @override
  Stream<CurrencyState> mapEventToState(CurrencyEvent event) async* {
    if (event is GetCurrenciesEvent) {
      yield CurrencyLoading();
      final dataOrFailure = await getCurrencies.call(NoParams());
      yield* _eitherLoadedOrErrorState(dataOrFailure);
    }
  }

  Stream<CurrencyState> _eitherLoadedOrErrorState(
      Either<Failure, List<Currency>> dataOrFailure) async* {
    yield dataOrFailure.fold(
      (failure) => CurrencyError(mapFailureToMessage(failure)),
      (currencies) => CurrencyLoaded(currencies),
    );
  }
}
