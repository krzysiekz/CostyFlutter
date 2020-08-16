import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../repositories/projects_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class GetProjects implements UseCase<List<Project>, NoParams> {
  final ProjectsRepository projectsRepository;

  GetProjects({@required this.projectsRepository});

  @override
  Future<Either<Failure, List<Project>>> call(NoParams params) {
    return projectsRepository.getProjects();
  }
}
