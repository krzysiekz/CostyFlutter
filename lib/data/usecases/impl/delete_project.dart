import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../repositories/projects_repository.dart';
import '../usecase.dart';

class DeleteProject implements UseCase<int, Params> {
  final ProjectsRepository projectsRepository;

  DeleteProject({@required this.projectsRepository});

  @override
  Future<Either<Failure, int>> call(Params params) {
    return projectsRepository.deleteProject(params.projectId);
  }
}

class Params extends Equatable {
  final int projectId;

  Params({@required this.projectId});

  @override
  List<Object> get props => [this.projectId];
}
