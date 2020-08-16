import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:share/share.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../services/report_formatter.dart';
import '../../services/report_generator.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class ShareReport implements UseCase<bool, ShareReportParams> {
  final ReportGenerator reportGenerator;
  final ReportFormatter reportFormatter;

  ShareReport({@required this.reportFormatter, @required this.reportGenerator});

  @override
  Future<Either<Failure, bool>> call(ShareReportParams params) async {
    try {
      final report = await reportGenerator.generate(params.project);
      if (report.entries.isNotEmpty) {
        final reportAsString = await reportFormatter.format(report);
        _shareReport(reportAsString, params.buildContext);
        return Right(true);
      } else {
        return Right(false);
      }
    } on Exception {
      return Left(ReportGenerationFailure());
    }
  }

  _shareReport(String reportAsString, BuildContext context) {
    final RenderBox box = context.findRenderObject();

    Share.share(reportAsString,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

class ShareReportParams extends Equatable {
  final Project project;
  final BuildContext buildContext;

  ShareReportParams({@required this.buildContext, @required this.project});

  @override
  List<Object> get props => [this.project];
}
