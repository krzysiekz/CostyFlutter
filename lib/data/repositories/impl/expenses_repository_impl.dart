import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';

import '../../datasources/expenses_datasource.dart';
import '../../errors/failures.dart';
import '../../models/currency.dart';
import '../../models/project.dart';
import '../../models/user.dart';
import '../../models/user_expense.dart';
import '../expenses_repository.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesDataSource expensesDataSource;

  ExpensesRepositoryImpl(this.expensesDataSource);

  @override
  Future<Either<Failure, int>> addExpense(
      {Project project,
      Decimal amount,
      Currency currency,
      String description,
      User user,
      List<User> receivers}) {
    return _getResponse(() {
      return expensesDataSource.addExpense(
          project: project,
          amount: amount,
          currency: currency,
          description: description,
          user: user,
          receivers: receivers);
    });
  }

  @override
  Future<Either<Failure, int>> deleteExpense(int expenseId) {
    return _getResponse(() {
      return expensesDataSource.deleteExpense(expenseId);
    });
  }

  @override
  Future<Either<Failure, List<UserExpense>>> getExpenses(
      Project project, List<User> users) {
    return _getResponse(() {
      return expensesDataSource.getExpenses(project, users);
    });
  }

  @override
  Future<Either<Failure, int>> modifyExpense(UserExpense expense) {
    return _getResponse(() {
      return expensesDataSource.modifyExpense(expense);
    });
  }

  Future<Either<Failure, T>> _getResponse<T>(Future<T> getter()) async {
    try {
      final response = await getter();
      return Right(response);
    } on Exception {
      return Left(DataSourceFailure());
    }
  }
}
