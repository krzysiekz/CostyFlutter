import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

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
      {@required this.addExpense,
      @required this.deleteExpense,
      @required this.modifyExpense,
      @required this.getExpenses});

  @override
  ExpenseState get initialState => ExpenseEmpty();

  @override
  Stream<ExpenseState> mapEventToState(ExpenseEvent event) async* {
    if (event is GetExpensesEvent) {
      yield* _processGetExpensesEvent(event);
    } else if (event is AddExpenseEvent) {
      yield* _processAddExpenseEvent(event);
    } else if (event is DeleteExpenseEvent) {
      yield* _processDeleteExpenseEvent(event);
    } else if (event is ModifyExpenseEvent) {
      yield* _processModifyExpenseEvent(event);
    }
  }

  Stream<ExpenseState> _processModifyExpenseEvent(
      ModifyExpenseEvent event) async* {
    yield ExpenseLoading();
    final dataOrFailure =
        await modifyExpense.call(ModifyExpenseParams(expense: event.expense));
    yield dataOrFailure.fold(
      (failure) => ExpenseError(mapFailureToMessage(failure)),
      (expenseId) => ExpenseModified(expenseId),
    );
  }

  Stream<ExpenseState> _processDeleteExpenseEvent(
      DeleteExpenseEvent event) async* {
    yield ExpenseLoading();
    final dataOrFailure = await deleteExpense
        .call(DeleteExpenseParams(expenseId: event.expenseId));
    yield dataOrFailure.fold(
      (failure) => ExpenseError(mapFailureToMessage(failure)),
      (expenseId) => ExpenseDeleted(expenseId),
    );
  }

  Stream<ExpenseState> _processAddExpenseEvent(AddExpenseEvent event) async* {
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
  }

  Stream<ExpenseState> _processGetExpensesEvent(GetExpensesEvent event) async* {
    yield ExpenseLoading();
    final dataOrFailure =
        await getExpenses.call(GetExpensesParams(project: event.project));
    yield dataOrFailure.fold(
      (failure) => ExpenseError(mapFailureToMessage(failure)),
      (expenses) => ExpenseLoaded(expenses),
    );
  }
}
