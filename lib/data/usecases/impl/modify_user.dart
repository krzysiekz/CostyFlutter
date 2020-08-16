import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class ModifyUser implements UseCase<int, ModifyUserParams> {
  final UsersRepository usersRepository;

  ModifyUser({@required this.usersRepository});

  @override
  Future<Either<Failure, int>> call(ModifyUserParams params) {
    return usersRepository.modifyUser(params.user);
  }
}

class ModifyUserParams extends Equatable {
  final User user;

  const ModifyUserParams({@required this.user});

  @override
  List<Object> get props => [user];
}
