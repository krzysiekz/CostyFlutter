import 'package:costy/data/models/report.dart';

import '../report_formatter.dart';

class ReportFormatterImpl implements ReportFormatter {
  @override
  Future<String> format(Report report) async {
    return report.toString();
  }
}
