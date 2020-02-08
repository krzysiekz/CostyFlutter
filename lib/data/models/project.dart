import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'currency.dart';
import 'user_expense.dart';

class Project extends Equatable {
  final List<UserExpense> expenses = [];

  final int id;
  final String name;
  final Currency defaultCurrency;
  final DateTime creationDateTime;

  Project({
    @required this.id,
    @required this.name,
    @required this.defaultCurrency,
    @required this.creationDateTime,
  });

  @override
  List<Object> get props => [this.id];

  void addExpense(UserExpense userExpense) {
    this.expenses.add(userExpense);
  }

  @override
  String toString() {
    return 'Project{expenses: $expenses, id: $id, name: $name, defaultCurrency: $defaultCurrency, creationDateTime: $creationDateTime}';
  }
}
