import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  @override
  ExpenseState get initialState => InitialExpenseState();

  @override
  Stream<ExpenseState> mapEventToState(
    ExpenseEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
