import 'package:equatable/equatable.dart';

import '../../data/models/user_expense.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();
}

class ExpenseEmpty extends ExpenseState {
  @override
  List<Object> get props => [];
}

class ExpenseLoading extends ExpenseState {
  @override
  List<Object> get props => [];
}

class ExpenseLoaded extends ExpenseState {
  final List<UserExpense> expenses;

  const ExpenseLoaded(this.expenses);

  @override
  List<Object> get props => [expenses];
}

class ExpenseAdded extends ExpenseState {
  final int expenseId;

  const ExpenseAdded(this.expenseId);

  @override
  List<Object> get props => [expenseId];
}

class ExpenseDeleted extends ExpenseState {
  final int expenseId;

  const ExpenseDeleted(this.expenseId);

  @override
  List<Object> get props => [expenseId];
}

class ExpenseModified extends ExpenseState {
  final int expenseId;

  const ExpenseModified(this.expenseId);

  @override
  List<Object> get props => [expenseId];
}

class ExpenseError extends ExpenseState {
  final String errorMessage;

  const ExpenseError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
