import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';
import '../../data/usecases/impl/add_project.dart';
import '../../data/usecases/impl/delete_project.dart';
import '../../data/usecases/impl/get_projects.dart';
import '../../data/usecases/impl/modify_project.dart';
import '../../data/usecases/usecase.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final GetProjects getProjects;
  final AddProject addProject;
  final ModifyProject modifyProject;
  final DeleteProject deleteProject;

  ProjectBloc(
      {this.getProjects,
      this.addProject,
      this.modifyProject,
      this.deleteProject})
      : super(ProjectEmpty());

  @override
  Stream<ProjectState> mapEventToState(ProjectEvent event) async* {
    if (event is GetProjectsEvent) {
      yield* _processGetProjectsEvent(event);
    } else if (event is AddProjectEvent) {
      yield* _processAddProjectEvent(event);
    } else if (event is DeleteProjectEvent) {
      yield* _processDeleteProjectEvent(event);
    } else if (event is ModifyProjectEvent) {
      yield* _processModifyProjectEvent(event);
    }
  }

  Stream<ProjectState> _processModifyProjectEvent(
      ModifyProjectEvent event) async* {
    yield ProjectLoading();
    final dataOrFailure =
        await modifyProject.call(ModifyProjectParams(project: event.project));
    yield dataOrFailure.fold(
      (failure) => ProjectError(mapFailureToMessage(failure)),
      (projectId) => ProjectModified(projectId),
    );
  }

  Stream<ProjectState> _processDeleteProjectEvent(
      DeleteProjectEvent event) async* {
    yield ProjectLoading();
    final dataOrFailure = await deleteProject
        .call(DeleteProjectParams(projectId: event.projectId));
    yield dataOrFailure.fold(
      (failure) => ProjectError(mapFailureToMessage(failure)),
      (projectId) => ProjectDeleted(projectId),
    );
  }

  Stream<ProjectState> _processAddProjectEvent(AddProjectEvent event) async* {
    yield ProjectLoading();
    final dataOrFailure = await addProject.call(AddProjectParams(
        defaultCurrency: event.defaultCurrency,
        projectName: event.projectName));
    yield dataOrFailure.fold(
      (failure) => ProjectError(mapFailureToMessage(failure)),
      (projectId) => ProjectAdded(projectId),
    );
  }

  Stream<ProjectState> _processGetProjectsEvent(GetProjectsEvent event) async* {
    yield ProjectLoading();
    final dataOrFailure = await getProjects.call(NoParams());
    yield dataOrFailure.fold(
      (failure) => ProjectError(mapFailureToMessage(failure)),
      (projects) => ProjectLoaded(projects),
    );
  }
}
