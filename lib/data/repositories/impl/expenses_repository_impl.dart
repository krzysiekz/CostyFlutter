import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';

import '../../../injection.dart';
import '../../datasources/expenses_datasource.dart';
import '../../datasources/users_datasource.dart';
import '../../errors/failures.dart';
import '../../models/currency.dart';
import '../../models/project.dart';
import '../../models/user.dart';
import '../../models/user_expense.dart';
import '../expenses_repository.dart';

@Singleton(as: ExpensesRepository, env: [Env.prod])
class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesDataSource expensesDataSource;
  final UsersDataSource usersDataSource;

  ExpensesRepositoryImpl(this.expensesDataSource, this.usersDataSource);

  @override
  Future<Either<Failure, int>> addExpense(
      {Project project,
      Decimal amount,
      Currency currency,
      String description,
      User user,
      List<User> receivers,
      DateTime dateTime}) {
    return _getResponse(() {
      return expensesDataSource.addExpense(
          project: project,
          amount: amount,
          currency: currency,
          description: description,
          user: user,
          receivers: receivers,
          dateTime: dateTime);
    });
  }

  @override
  Future<Either<Failure, int>> deleteExpense(int expenseId) {
    return _getResponse(() {
      return expensesDataSource.deleteExpense(expenseId);
    });
  }

  @override
  Future<Either<Failure, List<UserExpense>>> getExpenses(Project project) {
    return _getResponse(() async {
      final users = await usersDataSource.getUsers(project);
      return expensesDataSource.getExpenses(project, users);
    });
  }

  @override
  Future<Either<Failure, int>> modifyExpense(UserExpense expense) {
    return _getResponse(() {
      return expensesDataSource.modifyExpense(expense);
    });
  }

  Future<Either<Failure, T>> _getResponse<T>(
      Future<T> Function() getter) async {
    try {
      final response = await getter();
      return Right(response);
    } on Exception {
      return Left(DataSourceFailure());
    }
  }
}
