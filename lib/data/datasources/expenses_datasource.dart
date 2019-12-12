import 'package:decimal/decimal.dart';

import '../models/currency.dart';
import '../models/project.dart';
import '../models/user.dart';
import '../models/user_expense.dart';

abstract class ExpensesDataSource {
  Future<List<UserExpense>> getExpenses(Project project, List<User> users);

  Future<int> addExpense({
    Project project,
    Decimal amount,
    Currency currency,
    String description,
    User user,
    List<User> receivers,
  });

  Future<int> modifyExpense(UserExpense expense);

  Future<int> deleteExpense(int expenseId);
}
