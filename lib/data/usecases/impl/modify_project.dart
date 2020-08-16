import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../repositories/projects_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
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
