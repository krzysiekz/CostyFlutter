import 'package:costy/data/errors/failures.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/repositories/projects_repository.dart';
import 'package:costy/data/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetProjects implements UseCase<List<Project>, NoParams> {
  final ProjectsRepository projectsRepository;

  GetProjects({@required this.projectsRepository});

  @override
  Future<Either<Failure, List<Project>>> call(NoParams params) {
    return projectsRepository.getProjects();
  }
}
