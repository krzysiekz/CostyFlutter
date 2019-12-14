import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  @override
  CurrencyState get initialState => InitialCurrencyState();

  @override
  Stream<CurrencyState> mapEventToState(
    CurrencyEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
