import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/currency.dart';
import '../../repositories/projects_repository.dart';
import '../usecase.dart';

class ModifyProject implements UseCase<int, Params> {
  final ProjectsRepository projectsRepository;

  ModifyProject({@required this.projectsRepository});

  @override
  Future<Either<Failure, int>> call(Params params) {
    return projectsRepository.modifyProject(
        params.projectName, params.defaultCurrency);
  }
}

class Params extends Equatable {
  final String projectName;
  final Currency defaultCurrency;

  Params({@required this.projectName, @required this.defaultCurrency});

  @override
  List<Object> get props => [this.projectName, this.defaultCurrency];
}
