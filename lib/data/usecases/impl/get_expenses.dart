import 'package:costy/data/models/user.dart';
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
    return expensesRepository.getExpenses(params.project, params.users);
  }
}

class Params extends Equatable {
  final Project project;
  final List<User> users;

  Params({@required this.project, @required this.users});

  @override
  List<Object> get props => [this.project, this.users];
}
