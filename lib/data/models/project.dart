import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'currency.dart';
import 'user.dart';
import 'user_expense.dart';

class Project extends Equatable {
  final List<UserExpense> expenses = [];
  final List<User> users = [];
  
  final int id;
  final String name;
  final Currency defaultCurrency;

  Project({
    @required this.id,
    @required this.name,
    @required this.defaultCurrency,
  });

  @override
  List<Object> get props => [this.id];

  void addExpense(UserExpense userExpense) {
    this.expenses.add(userExpense);
  }

  @override
  String toString() {
    return "Project[id: $id, name: $name, users: $users, expenses: $expenses, defailtCurrency: $defaultCurrency]";
  }
}
