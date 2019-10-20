import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/user_expense.dart';
import '../../repositories/expenses_repository.dart';
import '../usecase.dart';

class GetExpensesForProject implements UseCase<List<UserExpense>, Params> {
  final ExpensesRepository expensesRepository;

  GetExpensesForProject({@required this.expensesRepository});

  @override
  Future<Either<Failure, List<UserExpense>>> call(Params params) {
    return expensesRepository.getExpenses(params.projectId);
  }
}

class Params extends Equatable {
  final int projectId;

  Params({@required this.projectId});

  @override
  List<Object> get props => [this.projectId];
}
