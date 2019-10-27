import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../errors/failures.dart';
import '../../models/project.dart';
import '../../repositories/users_repository.dart';
import '../usecase.dart';

class AddUser implements UseCase<int, Params> {
  final UsersRepository usersRepository;

  AddUser({@required this.usersRepository});

  @override
  Future<Either<Failure, int>> call(Params params) {
    return usersRepository.addUser(project: params.project, name: params.name);
  }
}

class Params extends Equatable {
  final Project project;
  final String name;

  Params({@required this.name, @required this.project});

  @override
  List<Object> get props => [this.name, this.project];
}
