import 'package:dartz/dartz.dart';

import '../errors/failures.dart';
import '../models/project.dart';
import '../models/user.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<User>>> getUsers(Project project);

  Future<Either<Failure, int>> addUser({Project project, String name});

  Future<Either<Failure, int>> modifyUser(User user);
}
