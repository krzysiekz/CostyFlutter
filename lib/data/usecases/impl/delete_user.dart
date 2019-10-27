import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../repositories/users_repository.dart';
import '../usecase.dart';

class DeleteUser implements UseCase<int, Params> {
  final UsersRepository usersRepository;

  DeleteUser({@required this.usersRepository});

  @override
  Future<Either<Failure, int>> call(Params params) {
    return usersRepository.deleteUser(params.userId);
  }
}

class Params extends Equatable {
  final int userId;

  Params({@required this.userId});

  @override
  List<Object> get props => [this.userId];
}
