import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../injection.dart';
import '../../models/report.dart';
import '../report_formatter.dart';

@Singleton(as: ReportFormatter, env: [Env.prod])
class ReportFormatterImpl implements ReportFormatter {
  static final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  @override
  Future<String> format(Report report) async {
    final reportBuffer = StringBuffer();
    reportBuffer.writeln(report.project.name);
    reportBuffer.writeln();

    for (final expense in report.project.expenses) {
      reportBuffer.writeln("${dateFormat.format(expense.dateTime)}, "
          "${expense.amount.toStringAsFixed(2)} ${expense.currency.name}, "
          "${expense.description}, ${expense.user.name} -> "
          "${expense.receivers.map((user) => user.name).toList().join(', ')}");
    }

    reportBuffer.writeln();

    for (final reportEntry in report.entries) {
      reportBuffer.writeln(
          "${reportEntry.sender.name} -> ${reportEntry.receiver.name}: "
          "${reportEntry.amount.toStringAsFixed(2)} ${reportEntry.currency.name}");
    }

    return reportBuffer.toString();
  }
}
