import 'package:dartz/dartz.dart';

import '../../datasources/users_datasource.dart';
import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../models/user.dart';
import '../users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersDataSource usersDataSource;

  UsersRepositoryImpl(this.usersDataSource);

  @override
  Future<Either<Failure, int>> addUser({Project project, String name}) async {
    return _getResponse(() {
      return usersDataSource.addUser(project: project, name: name);
    });
  }

  @override
  Future<Either<Failure, int>> deleteUser(int userId) async {
    return _getResponse(() {
      return usersDataSource.deleteUser(userId);
    });
  }

  @override
  Future<Either<Failure, List<User>>> getUsers(Project project) async {
    return _getResponse(() {
      return usersDataSource.getUsers(project);
    });
  }

  @override
  Future<Either<Failure, int>> modifyUser(User user) async {
    return _getResponse(() {
      return usersDataSource.modifyUser(user);
    });
  }

  Future<Either<Failure, T>> _getResponse<T>(Future<T> getter()) async {
    try {
      final response = await getter();
      return Right(response);
    } on Exception {
      return Left(DataSourceFailure());
    }
  }
}
