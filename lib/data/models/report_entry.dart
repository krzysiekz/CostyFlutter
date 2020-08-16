import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'currency.dart';
import 'user.dart';

class ReportEntry extends Equatable {
  final User sender;
  final User receiver;
  final Decimal amount;
  final Currency currency;

  const ReportEntry(
      {@required this.sender,
      @required this.receiver,
      @required this.amount,
      @required this.currency});

  @override
  List<Object> get props => [sender, receiver, amount, currency];

  @override
  String toString() {
    return "ReportEntry[sender: $sender, receiver: $receiver, amount: $amount, currency: $currency]";
  }
}
