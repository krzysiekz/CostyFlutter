import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/currency.dart';
import '../../models/project.dart';
import '../../models/user.dart';
import '../../repositories/expenses_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class AddExpense implements UseCase<int, AddExpenseParams> {
  final ExpensesRepository expensesRepository;

  AddExpense({@required this.expensesRepository});

  @override
  Future<Either<Failure, int>> call(AddExpenseParams params) {
    return expensesRepository.addExpense(
        project: params.project,
        amount: params.amount,
        currency: params.currency,
        description: params.description,
        user: params.user,
        receivers: params.receivers,
        dateTime: params.dateTime);
  }
}

class AddExpenseParams extends Equatable {
  final Project project;
  final Decimal amount;
  final String description;
  final Currency currency;
  final User user;
  final List<User> receivers;
  final DateTime dateTime;

  const AddExpenseParams(
      {@required this.amount,
      @required this.description,
      @required this.currency,
      @required this.user,
      @required this.receivers,
      @required this.project,
      @required this.dateTime});

  @override
  List<Object> get props =>
      [amount, description, currency, user, receivers, project, dateTime];
}
