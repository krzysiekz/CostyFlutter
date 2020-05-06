import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';
import '../../data/models/project.dart';
import '../../data/models/user_expense.dart';
import '../../data/usecases/impl/get_expenses.dart';
import '../../data/usecases/impl/get_report.dart';
import '../../data/usecases/impl/share_report.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetReport getReport;
  final GetExpenses getExpenses;
  final ShareReport shareReport;

  ReportBloc(this.getReport, this.getExpenses, this.shareReport);

  @override
  ReportState get initialState => ReportEmpty();

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is GetReportEvent) {
      yield* _processGetReportEvent(event);
    } else if (event is ShareReportEvent) {
      yield* _processShareReportEvent(event);
    }
  }

  Stream<ReportState> _processGetReportEvent(GetReportEvent event) async* {
    yield ReportLoading();

    final eitherExpenses =
        await getExpenses.call(GetExpensesParams(project: event.project));

    if (eitherExpenses.isLeft()) {
      yield ReportError(REPORT_GENERATION_FAILURE_MESSAGE);
    } else {
      final Project project = Project(
          id: event.project.id,
          name: event.project.name,
          defaultCurrency: event.project.defaultCurrency,
          creationDateTime: event.project.creationDateTime);

      List<UserExpense> expenses = eitherExpenses.getOrElse(() => List());
      expenses.forEach((expense) => project.addExpense(expense));

      final dataOrFailure =
          await getReport.call(GetReportParams(project: project));
      yield dataOrFailure.fold(
        (failure) => ReportError(mapFailureToMessage(failure)),
        (report) => ReportLoaded(report),
      );
    }
  }

  Stream<ReportState> _processShareReportEvent(ShareReportEvent event) async* {
    yield ReportLoading();

    final eitherExpenses =
        await getExpenses.call(GetExpensesParams(project: event.project));

    if (eitherExpenses.isLeft()) {
      yield ReportError(REPORT_GENERATION_FAILURE_MESSAGE);
    } else {
      final Project project = Project(
          id: event.project.id,
          name: event.project.name,
          defaultCurrency: event.project.defaultCurrency,
          creationDateTime: event.project.creationDateTime);

      List<UserExpense> expenses = eitherExpenses.getOrElse(() => List());
      expenses.forEach((expense) => project.addExpense(expense));

      final dataOrFailure = await shareReport.call(ShareReportParams(
          buildContext: event.buildContext, project: project));
      yield dataOrFailure.fold(
        (failure) => ReportError(mapFailureToMessage(failure)),
        (report) => ReportShared(),
      );
    }
  }
}
