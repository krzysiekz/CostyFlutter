import 'package:bloc_test/bloc_test.dart';
import 'package:costy/data/errors/failures.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/report.dart';
import 'package:costy/data/usecases/impl/get_expenses.dart';
import 'package:costy/data/usecases/impl/get_report.dart';
import 'package:costy/data/usecases/impl/share_report.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetReport extends Mock implements GetReport {}

class MockGetExpenses extends Mock implements GetExpenses {}

class MockShareReport extends Mock implements ShareReport {}

void main() {
  MockGetReport mockGetReport;
  MockGetExpenses mockGetExpenses;
  MockShareReport mockShareReport;
  ReportBloc bloc;

  setUp(() {
    mockGetReport = MockGetReport();
    mockGetExpenses = MockGetExpenses();
    bloc = ReportBloc(mockGetReport, mockGetExpenses, mockShareReport);
  });

  final tCreationDateTime = DateTime(2020, 1, 1, 10, 10, 10);
  final tProject = Project(
      id: 1,
      name: 'Test project',
      defaultCurrency: Currency(name: 'USD'),
      creationDateTime: tCreationDateTime);
  final tReport = Report(project: tProject);

  blocTest('should emit proper states when getting report',
      build: () {
        when(mockGetReport.call(any)).thenAnswer((_) async => Right(tReport));
        when(mockGetExpenses.call(any)).thenAnswer((_) async => Right(List()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetReportEvent(tProject)),
      expect: [ReportLoading(), ReportLoaded(tReport)]);

  blocTest('should emit proper states in case or error when generating report',
      build: () {
        when(mockGetReport.call(any))
            .thenAnswer((_) async => Left(ReportGenerationFailure()));
        when(mockGetExpenses.call(any)).thenAnswer((_) async => Right(List()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetReportEvent(tProject)),
      expect: [
        ReportLoading(),
        ReportError(reportGenerationFailureMessage)
      ]);

  blocTest('should emit proper states in case or error when getting expenses',
      build: () {
        when(mockGetReport.call(any)).thenAnswer((_) async => Right(tReport));
        when(mockGetExpenses.call(any))
            .thenAnswer((_) async => Left(DataSourceFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetReportEvent(tProject)),
      expect: [
        ReportLoading(),
        ReportError(reportGenerationFailureMessage)
      ]);
}
