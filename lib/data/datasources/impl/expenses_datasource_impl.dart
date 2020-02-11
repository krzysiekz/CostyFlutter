import 'package:decimal/decimal.dart';

import '../../models/currency.dart';
import '../../models/project.dart';
import '../../models/user.dart';
import '../../models/user_expense.dart';
import '../entities/user_expense_entity.dart';
import '../expenses_datasource.dart';
import '../hive_operations.dart';

class ExpensesDataSourceImpl implements ExpensesDataSource {
  static const BOX_NAME = 'expenses';

  final HiveOperations _hiveOperations;

  ExpensesDataSourceImpl(this._hiveOperations);

  @override
  Future<int> addExpense(
      {Project project,
      Decimal amount,
      Currency currency,
      String description,
      User user,
      List<User> receivers,
      DateTime dateTime}) async {
    final box = await _hiveOperations.openBox(BOX_NAME);
    final entity = UserExpenseEntity(
        projectId: project.id,
        userId: user.id,
        amount: amount.toString(),
        currency: currency.name,
        description: description,
        receiversIds: receivers.map((r) => r.id).toList(),
        dateTime: dateTime.toIso8601String());
    int response = await box.add(entity);
    return response;
  }

  @override
  Future<int> deleteExpense(int expenseId) async {
    final box = await _hiveOperations.openBox(BOX_NAME);
    await box.delete(expenseId);
    return expenseId;
  }

  @override
  Future<List<UserExpense>> getExpenses(
      Project project, List<User> users) async {
    final box = await _hiveOperations.openBox(BOX_NAME);
    final entityMap = box.toMap();
    return entityMap.entries
        .where((e) => (e.value as UserExpenseEntity).projectId == project.id)
        .map((entity) => _mapEntityToUserExpense(entity, users))
        .toList();
  }

  @override
  Future<int> modifyExpense(UserExpense expense) async {
    final box = await _hiveOperations.openBox(BOX_NAME);
    final oldEntity = box.get(expense.id) as UserExpenseEntity;
    final newEntity = UserExpenseEntity(
        projectId: oldEntity.projectId,
        userId: expense.user.id,
        amount: expense.amount.toString(),
        currency: expense.currency.name,
        description: expense.description,
        receiversIds: expense.receivers.map((r) => r.id).toList(),
        dateTime: expense.dateTime.toIso8601String());
    await box.put(expense.id, newEntity);
    return expense.id;
  }

  UserExpense _mapEntityToUserExpense(e, List<User> users) {
    final UserExpenseEntity entity = e.value;
    return UserExpense(
        id: e.key,
        description: entity.description,
        amount: Decimal.parse(entity.amount),
        currency: Currency(name: entity.currency),
        user: users.firstWhere((user) => user.id == entity.userId),
        receivers: entity.receiversIds
            .map((id) => users.firstWhere((u) => u.id == id))
            .toList(),
        dateTime: DateTime.parse(entity.dateTime));
  }
}
