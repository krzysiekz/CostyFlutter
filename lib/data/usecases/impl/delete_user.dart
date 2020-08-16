import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../repositories/users_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class DeleteUser implements UseCase<int, DeleteUserParams> {
  final UsersRepository usersRepository;

  DeleteUser({@required this.usersRepository});

  @override
  Future<Either<Failure, int>> call(DeleteUserParams params) {
    return usersRepository.deleteUser(params.userId);
  }
}

class DeleteUserParams extends Equatable {
  final int userId;

  DeleteUserParams({@required this.userId});

  @override
  List<Object> get props => [this.userId];
}
