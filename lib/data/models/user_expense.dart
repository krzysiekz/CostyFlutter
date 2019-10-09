import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'currency.dart';
import 'user.dart';

class UserExpense extends Equatable {
  final int id;
  final List<User> receivers;
  final User user;
  final Decimal amount;
  final String description;
  final Currency currency;

  UserExpense(
      {@required this.id,
      @required this.receivers,
      @required this.user,
      @required this.amount,
      @required this.description,
      @required this.currency});

  @override
  List<Object> get props =>
      [this.receivers, this.user, this.amount, this.description, this.currency];

  @override
  String toString() {
    return "UserExpense[id: $id, user: $user, amount: $amount, currency: $currency, description: $description, receivers: $receivers]";
  }
}
