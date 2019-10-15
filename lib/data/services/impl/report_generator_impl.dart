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

    _createReportEntries(calculationsMap, report);
    _removeRedundantEntriesFromCycles(report);

    return report;
  }

  void _removeRedundantEntriesFromCycles(
    Report report,
  ) {
    while (_doesCycleExist(report)) {
      for (ReportEntry entry in report.entries) {
        final cycle = _findCycle(
            entry.sender, entry.sender, report.entries, entry.currency);
        if (cycle.isNotEmpty) {
          _processCycle(cycle, report);
          break;
        }
      }
    }
  }

  bool _doesCycleExist(Report report) {
    return report.entries.any((entry) => _findCycle(
          entry.sender,
          entry.sender,
          report.entries,
          entry.currency,
        ).isNotEmpty);
  }

  void _createReportEntries(
    Map<CalculationKey, Decimal> calculationsMap,
    Report report,
  ) {
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
  }

  void _processCycle(List<ReportEntry> cycle, Report report) {
    final entryWithMinimalAmount = _findMinimalElementInCycle(cycle);
    _createNewReportEntries(cycle, entryWithMinimalAmount, report);
    _removeOldReportEntries(report, cycle);
  }

  void _removeOldReportEntries(Report report, List<ReportEntry> cycle) =>
      report.entries.removeWhere((entry) => cycle.contains(entry));

  void _createNewReportEntries(List<ReportEntry> cycle,
      ReportEntry entryWithMinimalAmount, Report report) {
    cycle.where((entry) => entry != entryWithMinimalAmount).forEach((entry) =>
        report.addEntry(ReportEntry(
            amount: entry.amount - entryWithMinimalAmount.amount,
            currency: entry.currency,
            receiver: entry.receiver,
            sender: entry.sender)));
  }

  ReportEntry _findMinimalElementInCycle(List<ReportEntry> cycle) =>
      cycle.reduce((curr, next) => curr.amount < next.amount ? curr : next);

  List<ReportEntry> _findCycle(
    User root,
    User current,
    List<ReportEntry> entries,
    Currency currency,
  ) {
    final connected = _findConnected(current, currency, entries);
    if (connected.isEmpty) return [];

    final rootConnection = connected.firstWhere(
      (entry) => entry.receiver == root,
      orElse: () => null,
    );

    if (rootConnection != null) {
      return [rootConnection];
    } else {
      for (ReportEntry entry in connected) {
        final cycle = _findCycle(root, entry.receiver, entries, currency);
        if (cycle.isNotEmpty) {
          cycle.add(entry);
          return cycle;
        }
      }
      return [];
    }
  }

  List<ReportEntry> _findConnected(
          User root, Currency currency, List<ReportEntry> entries) =>
      entries
          .where((entry) => entry.sender == root && entry.currency == currency)
          .toList();
}

class CalculationKey extends Equatable {
  final User sender;
  final User receiver;
  final Currency currency;

  CalculationKey({this.sender, this.receiver, this.currency});

  @override
  List<Object> get props => [this.sender, this.receiver, this.currency];
}
