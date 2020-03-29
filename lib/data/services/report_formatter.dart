import '../models/report.dart';

abstract class ReportFormatter {
  Future<String> format(Report report);
}
