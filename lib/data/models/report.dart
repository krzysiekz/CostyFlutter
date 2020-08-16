import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'project.dart';
import 'report_entry.dart';

class Report extends Equatable {
  final List<ReportEntry> entries = [];
  final Project project;

  Report({@required this.project});

  @override
  List<Object> get props => [project, entries];

  void addEntry(ReportEntry reportEntry) {
    entries.add(reportEntry);
  }

  @override
  String toString() {
    return "Report[project: $project, entries: $entries]";
  }
}
