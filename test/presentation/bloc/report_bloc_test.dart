import 'package:bloc_test/bloc_test.dart';
import 'package:costy/data/errors/failures.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/report.dart';
import 'package:costy/data/usecases/impl/get_report.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetReport extends Mock implements GetReport {}

void main() {
  MockGetReport mockGetReport;
  ReportBloc bloc;

  setUp(() {
    mockGetReport = MockGetReport();
    bloc = ReportBloc(mockGetReport);
  });

  final tCreationDateTime = DateTime(2020, 1, 1, 10, 10, 10);
  final tProject = Project(
      id: 1,
      name: 'Test project',
      defaultCurrency: Currency(name: 'USD'),
      creationDateTime: tCreationDateTime);
  final tReport = Report(project: tProject);

  blocTest('should emit empty state initially', build: () {
    return bloc;
  }, expect: [ReportEmpty()]);

  blocTest('should emit proper states when getting report',
      build: () {
        when(mockGetReport.call(any)).thenAnswer((_) async => Right(tReport));
        return bloc;
      },
      act: (bloc) => bloc.add(GetReportEvent(tProject)),
      expect: [ReportEmpty(), ReportLoading(), ReportLoaded(tReport)]);

  blocTest('should emit proper states in case or error',
      build: () {
        when(mockGetReport.call(any))
            .thenAnswer((_) async => Left(ReportGenerationFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetReportEvent(tProject)),
      expect: [
        ReportEmpty(),
        ReportLoading(),
        ReportError(REPORT_GENERATION_FAILURE_MESSAGE)
      ]);
}
