import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';
import '../usecase.dart';

class ModifyUser implements UseCase<int, Params> {
  final UsersRepository usersRepository;

  ModifyUser({@required this.usersRepository});

  @override
  Future<Either<Failure, int>> call(Params params) {
    return usersRepository.modifyUser(params.user);
  }
}

class Params extends Equatable {
  final User user;

  Params({@required this.user});

  @override
  List<Object> get props => [this.user];
}
