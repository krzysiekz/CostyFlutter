import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../repositories/expenses_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class DeleteExpense implements UseCase<int, DeleteExpenseParams> {
  final ExpensesRepository expensesRepository;

  DeleteExpense({@required this.expensesRepository});

  @override
  Future<Either<Failure, int>> call(DeleteExpenseParams params) {
    return expensesRepository.deleteExpense(params.expenseId);
  }
}

class DeleteExpenseParams extends Equatable {
  final int expenseId;

  DeleteExpenseParams({@required this.expenseId});

  @override
  List<Object> get props => [this.expenseId];
}
