import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';
import '../usecase.dart';

class GetUsersForProject implements UseCase<List<User>, Params> {
  final UsersRepository usersRepository;

  GetUsersForProject({@required this.usersRepository});

  @override
  Future<Either<Failure, List<User>>> call(Params params) {
    return usersRepository.getUsers(params.project);
  }
}

class Params extends Equatable {
  final Project project;

  Params({@required this.project});

  @override
  List<Object> get props => [this.project];
}
