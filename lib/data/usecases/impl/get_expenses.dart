import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../models/user_expense.dart';
import '../../repositories/expenses_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class GetExpenses implements UseCase<List<UserExpense>, GetExpensesParams> {
  final ExpensesRepository expensesRepository;

  GetExpenses({@required this.expensesRepository});

  @override
  Future<Either<Failure, List<UserExpense>>> call(GetExpensesParams params) {
    return expensesRepository.getExpenses(params.project);
  }
}

class GetExpensesParams extends Equatable {
  final Project project;

  GetExpensesParams({@required this.project});

  @override
  List<Object> get props => [this.project];
}
