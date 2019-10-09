import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Project extends Equatable {
  final List<UserExpense> expenses = [];
  final List<User> users = [];
  final int id;
  final String name;
  Currency defaultCurrency;

  Project({
    @required this.id,
    @required this.name,
    this.defaultCurrency,
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
