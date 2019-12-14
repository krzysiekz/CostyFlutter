import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../models/user_expense.dart';
import '../../repositories/expenses_repository.dart';
import '../usecase.dart';

class GetExpenses implements UseCase<List<UserExpense>, Params> {
  final ExpensesRepository expensesRepository;

  GetExpenses({@required this.expensesRepository});

  @override
  Future<Either<Failure, List<UserExpense>>> call(Params params) {
    return expensesRepository.getExpenses(params.project);
  }
}

class Params extends Equatable {
  final Project project;

  Params({@required this.project});

  @override
  List<Object> get props => [this.project];
}
