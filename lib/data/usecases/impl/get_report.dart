import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../models/report.dart';
import '../../services/report_generator.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class GetReport implements UseCase<Report, GetReportParams> {
  final ReportGenerator reportGenerator;

  GetReport({@required this.reportGenerator});

  @override
  Future<Either<Failure, Report>> call(GetReportParams params) async {
    try {
      final report = await reportGenerator.generate(params.project);
      return Right(report);
    } on Exception {
      return Left(ReportGenerationFailure());
    }
  }
}

class GetReportParams extends Equatable {
  final Project project;

  const GetReportParams({@required this.project});

  @override
  List<Object> get props => [project];
}
