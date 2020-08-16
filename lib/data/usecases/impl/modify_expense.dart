import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/user_expense.dart';
import '../../repositories/expenses_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class ModifyExpense implements UseCase<int, ModifyExpenseParams> {
  final ExpensesRepository expensesRepository;

  ModifyExpense({@required this.expensesRepository});

  @override
  Future<Either<Failure, int>> call(ModifyExpenseParams params) {
    return expensesRepository.modifyExpense(params.expense);
  }
}

class ModifyExpenseParams extends Equatable {
  final UserExpense expense;

  ModifyExpenseParams({@required this.expense});

  @override
  List<Object> get props => [this.expense];
}
