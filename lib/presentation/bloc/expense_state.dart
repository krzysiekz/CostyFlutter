import 'package:equatable/equatable.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();
}

class InitialExpenseState extends ExpenseState {
  @override
  List<Object> get props => [];
}
