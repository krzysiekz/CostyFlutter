import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../models/report.dart';
import '../../services/report_generator.dart';
import '../usecase.dart';

class GetReport implements UseCase<Report, Params> {
  final ReportGenerator reportGenerator;

  GetReport({@required this.reportGenerator});

  @override
  Future<Either<Failure, Report>> call(Params params) async {
    final report = await reportGenerator.generate(params.project);
    return Right(report);
  }
}

class Params extends Equatable {
  final Project project;

  Params({@required this.project});

  @override
  List<Object> get props => [this.project];
}
