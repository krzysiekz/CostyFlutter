import '../../data/errors/failures.dart';

export 'currency_bloc.dart';
export 'currency_event.dart';
export 'currency_state.dart';
export 'expense_bloc.dart';
export 'expense_event.dart';
export 'expense_state.dart';
export 'project_bloc.dart';
export 'project_event.dart';
export 'project_state.dart';
export 'report_bloc.dart';
export 'report_event.dart';
export 'report_state.dart';
export 'user_bloc.dart';
export 'user_event.dart';
export 'user_state.dart';

const String datasouceFailureMessage = 'Data Source Failure';
const String reportGenerationFailureMessage =
    'Error occurred during report generation.';
const String unexpectedErrorMessage = 'Unexpected error';

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case DataSourceFailure:
      return datasouceFailureMessage;
    case ReportGenerationFailure:
      return reportGenerationFailureMessage;
    default:
      return unexpectedErrorMessage;
  }
}
