import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/data/usecases/impl/get_expenses.dart';

import './bloc.dart';
import '../../data/usecases/impl/get_report.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetReport getReport;
  final GetExpenses getExpenses;

  ReportBloc(this.getReport, this.getExpenses);

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

    final Project project = event.project;
    final eitherExpenses =
        await getExpenses.call(GetExpensesParams(project: event.project));

    if (eitherExpenses.isLeft()) {
      yield ReportError(REPORT_GENERATION_FAILURE_MESSAGE);
    } else {
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
}
