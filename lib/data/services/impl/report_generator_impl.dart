import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

import '../../models/currency.dart';
import '../../models/project.dart';
import '../../models/report.dart';
import '../../models/report_entry.dart';
import '../../models/user.dart';
import '../report_generator.dart';

class ReportGeneratorImpl implements ReportGenerator {
  @override
  Future<Report> generate(Project project) async {
    final report = Report(project: project);
    final Map<CalculationKey, Decimal> calculationsMap = Map();

    project.expenses.forEach((expense) {
      Decimal baseAmount =
          expense.amount / Decimal.fromInt(expense.receivers.length);

      expense.receivers.forEach((receiver) {
        final key = CalculationKey(
            sender: expense.user,
            receiver: receiver,
            currency: expense.currency);

        final reverseKey = CalculationKey(
            receiver: expense.user,
            sender: receiver,
            currency: expense.currency);

        if (calculationsMap.containsKey(key)) {
          calculationsMap.update(key, (oldValue) => oldValue + baseAmount);
        } else if (calculationsMap.containsKey(reverseKey)) {
          calculationsMap.update(
              reverseKey, (oldValue) => oldValue - baseAmount);
        } else {
          calculationsMap.putIfAbsent(key, () => baseAmount);
        }
      });
    });

    calculationsMap.forEach((key, value) {
      if (key.sender != key.receiver && value != Decimal.zero) {
        if (value > Decimal.zero) {
          report.addEntry(ReportEntry(
              currency: key.currency,
              receiver: key.sender,
              sender: key.receiver,
              amount: value));
        } else {
          report.addEntry(ReportEntry(
              currency: key.currency,
              receiver: key.receiver,
              sender: key.sender,
              amount: Decimal.fromInt(-1) * value));
        }
      }
    });

    return report;
  }
}

class CalculationKey extends Equatable {
  final User sender;
  final User receiver;
  final Currency currency;

  CalculationKey({this.sender, this.receiver, this.currency});

  @override
  List<Object> get props => [this.sender, this.receiver, this.currency];
}
