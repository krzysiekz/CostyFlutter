import 'package:dartz/dartz.dart';

import '../errors/failures.dart';
import '../models/project.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<Project>>> getProjects();
}