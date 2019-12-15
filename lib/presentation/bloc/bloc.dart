import 'package:costy/data/errors/failures.dart';

export 'currency_bloc.dart';
export 'currency_event.dart';
export 'currency_state.dart';
export 'expense_bloc.dart';
export 'expense_event.dart';
export 'expense_state.dart';
export 'project_bloc.dart';
export 'project_event.dart';
export 'project_state.dart';
export 'user_bloc.dart';
export 'user_event.dart';
export 'user_state.dart';

const String DATASOURCE_FAILURE_MESSAGE = 'Data Source Failure';
const String UNEXPECTED_ERROR_MESSAGE = 'Unexpected error';

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case DataSourceFailure:
      return DATASOURCE_FAILURE_MESSAGE;
    default:
      return UNEXPECTED_ERROR_MESSAGE;
  }
}
