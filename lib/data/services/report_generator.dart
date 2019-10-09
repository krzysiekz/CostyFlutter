import '../models/project.dart';
import '../models/report.dart';

abstract class ReportGenerator {
  Future<Report> generate(Project project);
}
