import 'package:equatable/equatable.dart';

import '../../data/models/report.dart';

abstract class ReportState extends Equatable {
  const ReportState();
}

class ReportEmpty extends ReportState {
  @override
  List<Object> get props => [];
}

class ReportLoading extends ReportState {
  @override
  List<Object> get props => [];
}

class ReportLoaded extends ReportState {
  final Report report;

  ReportLoaded(this.report);

  @override
  List<Object> get props => [];
}

class ReportError extends ReportState {
  final String errorMessage;

  ReportError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ReportShared extends ReportState {
  @override
  List<Object> get props => [];
}
