import 'package:dartz/dartz.dart';

import '../../datasources/projects_datasource.dart';
import '../../errors/failures.dart';
import '../../models/currency.dart';
import '../../models/project.dart';
import '../projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsDataSource projectsDataSource;

  ProjectsRepositoryImpl(this.projectsDataSource);

  Future<Either<Failure, T>> _getResponse<T>(Future<T> getter()) async {
    try {
      final response = await getter();
      return Right(response);
    } on Exception {
      return Left(DataSourceFailure());
    }
  }

  @override
  Future<Either<Failure, int>> addProject(
    String projectName,
    Currency defaultCurrency,
    DateTime creationDateTime,
  ) {
    return _getResponse(() {
      return projectsDataSource.addProject(
        projectName,
        defaultCurrency,
        creationDateTime,
      );
    });
  }

  @override
  Future<Either<Failure, int>> deleteProject(int projectId) {
    return _getResponse(() {
      return projectsDataSource.deleteProject(projectId);
    });
  }

  @override
  Future<Either<Failure, List<Project>>> getProjects() {
    return _getResponse(() {
      return projectsDataSource.getProjects();
    });
  }

  @override
  Future<Either<Failure, int>> modifyProject(Project project) {
    return _getResponse(() {
      return projectsDataSource.modifyProject(project);
    });
  }
}
