import 'package:decimal/decimal.dart';

import '../../models/currency.dart';
import '../../models/project.dart';
import '../../models/user.dart';
import '../../models/user_expense.dart';
import '../entities/user_expense_entity.dart';
import '../expenses_datasource.dart';
import '../hive_operations.dart';

class ExpensesDataSourceImpl implements ExpensesDataSource {
  static const _BOX_NAME = 'expenses';

  final HiveOperations _hiveOperations;

  ExpensesDataSourceImpl(this._hiveOperations);

  @override
  Future<int> addExpense({
    Project project,
    Decimal amount,
    Currency currency,
    String description,
    User user,
    List<User> receivers,
  }) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    final entity = UserExpenseEntity(
        projectId: project.id,
        userId: user.id,
        amount: amount,
        currency: currency.name,
        description: description,
        receiversIds: receivers.map((r) => r.id).toList());
    return box.add(entity);
  }

  @override
  Future<int> deleteExpense(int expenseId) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    await box.delete(expenseId);
    return expenseId;
  }

  @override
  Future<List<UserExpense>> getExpenses(
      Project project, List<User> users) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    final entityMap = box.toMap();
    return entityMap.entries
        .where((e) => (e.value as UserExpenseEntity).projectId == project.id)
        .map((entity) => _mapEntityToUserExpense(entity, users))
        .toList();
  }

  @override
  Future<int> modifyExpense(UserExpense expense) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    final oldEntity = box.get(expense.id) as UserExpenseEntity;
    final newEntity = UserExpenseEntity(
        projectId: oldEntity.projectId,
        userId: expense.user.id,
        amount: expense.amount,
        currency: expense.currency.name,
        description: expense.description,
        receiversIds: expense.receivers.map((r) => r.id).toList());
    await box.put(expense.id, newEntity);
    return expense.id;
  }

  UserExpense _mapEntityToUserExpense(e, List<User> users) {
    final UserExpenseEntity entity = e.value;
    return UserExpense(
        id: e.key,
        description: entity.description,
        amount: entity.amount,
        currency: Currency(name: entity.currency),
        user: users.firstWhere((user) => user.id == entity.userId),
        receivers: entity.receiversIds
            .map((id) => users.firstWhere((u) => u.id == id)).toList());
  }
}