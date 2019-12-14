import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import './bloc.dart';
import '../../data/errors/failures.dart';
import '../../data/models/currency.dart';
import '../../data/usecases/impl/get_currencies.dart';
import '../../data/usecases/usecase.dart';

const String DATASOURCE_FAILURE_MESSAGE = 'Data Source Failure';
const String UNEXPECTED_ERROR_MESSAGE = 'Unexpected error';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetCurrencies getCurrencies;

  CurrencyBloc(this.getCurrencies);

  @override
  CurrencyState get initialState => CurrencyEmpty();

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
      (failure) => CurrencyError(_mapFailureToMessage(failure)),
      (currencies) => CurrencyLoaded(currencies),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case DataSourceFailure:
        return DATASOURCE_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_ERROR_MESSAGE;
    }
  }
}
