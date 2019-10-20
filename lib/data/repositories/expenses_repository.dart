import 'package:dartz/dartz.dart';

import '../errors/failures.dart';
import '../models/user_expense.dart';

abstract class ExpensesRepository {
  Future<Either<Failure, List<UserExpense>>> getExpenses(int projectId);
}