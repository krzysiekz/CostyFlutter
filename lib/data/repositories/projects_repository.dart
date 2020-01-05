import 'package:dartz/dartz.dart';

import '../errors/failures.dart';
import '../models/currency.dart';
import '../models/project.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<Project>>> getProjects();

  Future<Either<Failure, int>> addProject(
      String projectName, Currency defaultCurrency, DateTime creationDateTime);

  Future<Either<Failure, int>> deleteProject(int projectId);

  Future<Either<Failure, int>> modifyProject(Project project);
}
