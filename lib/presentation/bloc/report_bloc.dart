import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';
import '../../data/usecases/impl/get_report.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetReport getReport;

  ReportBloc(this.getReport);

  @override
  ReportState get initialState => ReportEmpty();

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is GetReportEvent) {
      yield* _processGetReportEvent(event);
    }
  }

  Stream<ReportState> _processGetReportEvent(GetReportEvent event) async* {
    yield ReportLoading();
    final dataOrFailure =
        await getReport.call(GetReportParams(project: event.project));
    yield dataOrFailure.fold(
      (failure) => ReportError(mapFailureToMessage(failure)),
      (report) => ReportLoaded(report),
    );
  }
}
