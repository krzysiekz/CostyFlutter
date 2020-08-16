import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../injection.dart';
import '../../errors/failures.dart';
import '../../models/currency.dart';
import '../../repositories/projects_repository.dart';
import '../usecase.dart';

@Singleton(env: [Env.prod])
class AddProject implements UseCase<int, AddProjectParams> {
  final ProjectsRepository projectsRepository;

  AddProject({@required this.projectsRepository});

  @override
  Future<Either<Failure, int>> call(AddProjectParams params) {
    return projectsRepository.addProject(
        params.projectName, params.defaultCurrency, DateTime.now());
  }
}

class AddProjectParams extends Equatable {
  final String projectName;
  final Currency defaultCurrency;

  AddProjectParams({@required this.projectName, @required this.defaultCurrency});

  @override
  List<Object> get props => [this.projectName, this.defaultCurrency];
}
