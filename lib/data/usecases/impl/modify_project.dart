import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../repositories/projects_repository.dart';
import '../usecase.dart';

class ModifyProject implements UseCase<int, ModifyProjectParams> {
  final ProjectsRepository projectsRepository;

  ModifyProject({@required this.projectsRepository});

  @override
  Future<Either<Failure, int>> call(ModifyProjectParams params) {
    return projectsRepository.modifyProject(params.project);
  }
}

class ModifyProjectParams extends Equatable {
  final Project project;

  ModifyProjectParams({@required this.project});

  @override
  List<Object> get props => [this.project];
}
