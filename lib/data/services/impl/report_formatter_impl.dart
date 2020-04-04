import 'package:costy/data/models/report.dart';
import 'package:intl/intl.dart';

import '../report_formatter.dart';

class ReportFormatterImpl implements ReportFormatter {
  static final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  @override
  Future<String> format(Report report) async {
    var reportBuffer = StringBuffer();
    reportBuffer.writeln(report.project.name);
    reportBuffer.writeln();

    report.project.expenses.forEach((expense) {
      reportBuffer.writeln("${dateFormat.format(expense.dateTime)}, "
          "${expense.amount.toStringAsFixed(2)} ${expense.currency.name}, "
          "${expense.description}, ${expense.user.name} -> "
          "${expense.receivers.map((user) => user.name).toList().join(', ')}");
    });

    reportBuffer.writeln();

    report.entries.forEach((reportEntry) {
      reportBuffer.writeln(
          "${reportEntry.sender.name} -> ${reportEntry.receiver.name}: "
          "${reportEntry.amount.toStringAsFixed(2)} ${reportEntry.currency.name}");
    });

    return reportBuffer.toString();
  }
}
