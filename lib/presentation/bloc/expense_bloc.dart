import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';
import '../../data/usecases/impl/add_expense.dart';
import '../../data/usecases/impl/delete_expense.dart';
import '../../data/usecases/impl/get_expenses.dart';
import '../../data/usecases/impl/modify_expense.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final AddExpense addExpense;
  final DeleteExpense deleteExpense;
  final ModifyExpense modifyExpense;
  final GetExpenses getExpenses;

  ExpenseBloc(
      {this.addExpense,
      this.deleteExpense,
      this.modifyExpense,
      this.getExpenses});

  @override
  ExpenseState get initialState => ExpenseEmpty();

  @override
  Stream<ExpenseState> mapEventToState(ExpenseEvent event) async* {
    if (event is GetExpensesEvent) {
      yield ExpenseLoading();
      final dataOrFailure =
          await getExpenses.call(GetExpensesParams(project: event.project));
      yield dataOrFailure.fold(
        (failure) => ExpenseError(mapFailureToMessage(failure)),
        (expenses) => ExpenseLoaded(expenses),
      );
    } else if (event is AddExpenseEvent) {
      yield ExpenseLoading();
      final dataOrFailure = await addExpense.call(AddExpenseParams(
          project: event.project,
          amount: event.amount,
          currency: event.currency,
          description: event.description,
          receivers: event.receivers,
          user: event.user));
      yield dataOrFailure.fold(
        (failure) => ExpenseError(mapFailureToMessage(failure)),
        (expenseId) => ExpenseAdded(expenseId),
      );
    } else if (event is DeleteExpenseEvent) {
      yield ExpenseLoading();
      final dataOrFailure = await deleteExpense
          .call(DeleteExpenseParams(expenseId: event.expenseId));
      yield dataOrFailure.fold(
        (failure) => ExpenseError(mapFailureToMessage(failure)),
        (expenseId) => ExpenseDeleted(expenseId),
      );
    } else if (event is ModifyExpenseEvent) {
      yield ExpenseLoading();
      final dataOrFailure =
          await modifyExpense.call(ModifyExpenseParams(expense: event.expense));
      yield dataOrFailure.fold(
        (failure) => ExpenseError(mapFailureToMessage(failure)),
        (expenseId) => ExpenseModified(expenseId),
      );
    }
  }
}
