import 'package:equatable/equatable.dart';

import '../../data/models/project.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();
}

class GetReportEvent extends ReportEvent {
  final Project project;

  GetReportEvent(this.project);

  @override
  List<Object> get props => [project];
}
