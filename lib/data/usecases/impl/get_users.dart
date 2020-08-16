import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
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

  const GetUsersParams({@required this.project});

  @override
  List<Object> get props => [project];
}
