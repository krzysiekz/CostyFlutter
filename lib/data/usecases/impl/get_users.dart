import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';
import '../usecase.dart';

class GetUsers implements UseCase<List<User>, GetUsersParams> {
  final UsersRepository usersRepository;

  GetUsers({@required this.usersRepository});

  @override
  Future<Either<Failure, List<User>>> call(GetUsersParams params) {
    return usersRepository.getUsers(params.project);
  }
}

class GetUsersParams extends Equatable {
  final Project project;

  GetUsersParams({@required this.project});

  @override
  List<Object> get props => [this.project];
}
