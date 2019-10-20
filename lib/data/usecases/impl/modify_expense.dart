import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/currency.dart';
import '../../models/user.dart';
import '../../repositories/expenses_repository.dart';
import '../usecase.dart';

class ModifyExpense implements UseCase<int, Params> {
  final ExpensesRepository expensesRepository;

  ModifyExpense({@required this.expensesRepository});

  @override
  Future<Either<Failure, int>> call(Params params) {
    return expensesRepository.modifyExpense(
        expenseId: params.expenseId,
        amount: params.amount,
        currency: params.currency,
        description: params.description,
        user: params.user,
        receivers: params.receivers);
  }
}

class Params extends Equatable {
  final int expenseId;
  final Decimal amount;
  final String description;
  final Currency currency;
  final User user;
  final List<User> receivers;

  Params(
      {@required this.amount,
      @required this.description,
      @required this.currency,
      @required this.user,
      @required this.receivers,
      @required this.expenseId});

  @override
  List<Object> get props => [
        this.amount,
        this.description,
        this.currency,
        this.user,
        this.receivers,
        this.expenseId
      ];
}
