import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/report.dart';
import 'package:costy/data/services/report_generator.dart';
import 'package:costy/data/usecases/impl/get_report.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockReportGenerator extends Mock implements ReportGenerator {}

void main() {
  GetReport usecase;
  MockReportGenerator mockReportGenerator;

  setUp(() {
    mockReportGenerator = MockReportGenerator();
    usecase = GetReport(reportGenerator: mockReportGenerator);
  });

  final tProject = Project(
      id: 1, name: 'Test project', defaultCurrency: Currency(name: 'USD'));
  final tReport = Report(project: tProject);

  test('should get report from the service', () async {
    //arrange
    when(mockReportGenerator.generate(tProject))
        .thenAnswer((_) async => tReport);
    //act
    final result = await usecase.call(Params(project: tProject));
    //assert
    expect(result, equals(Right(tReport)));
    verify(mockReportGenerator.generate(tProject));
  });
}
