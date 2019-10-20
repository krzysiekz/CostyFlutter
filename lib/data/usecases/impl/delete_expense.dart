import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../repositories/expenses_repository.dart';
import '../usecase.dart';

class DeleteExpense implements UseCase<int, Params> {
  final ExpensesRepository expensesRepository;

  DeleteExpense({@required this.expensesRepository});

  @override
  Future<Either<Failure, int>> call(Params params) {
    return expensesRepository.deleteExpense(params.expenseId);
  }
}

class Params extends Equatable {
  final int expenseId;

  Params({@required this.expenseId});

  @override
  List<Object> get props => [this.expenseId];
}
