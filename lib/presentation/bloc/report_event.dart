import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../data/models/project.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();
}

class GetReportEvent extends ReportEvent {
  final Project project;

  const GetReportEvent(this.project);

  @override
  List<Object> get props => [project];
}

class ShareReportEvent extends ReportEvent {
  final Project project;
  final BuildContext buildContext;

  const ShareReportEvent(this.project, this.buildContext);

  @override
  List<Object> get props => [project];
}
