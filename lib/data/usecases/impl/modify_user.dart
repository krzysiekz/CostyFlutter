import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';
import '../usecase.dart';

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

  ModifyUserParams({@required this.user});

  @override
  List<Object> get props => [this.user];
}
