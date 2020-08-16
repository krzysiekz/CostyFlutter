import 'package:equatable/equatable.dart';

import '../../data/models/currency.dart';
import '../../data/models/project.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();
}

class GetProjectsEvent extends ProjectEvent {
  @override
  List<Object> get props => [];
}

class AddProjectEvent extends ProjectEvent {
  final String projectName;
  final Currency defaultCurrency;

  const AddProjectEvent({this.projectName, this.defaultCurrency});

  @override
  List<Object> get props => [projectName, defaultCurrency];
}

class DeleteProjectEvent extends ProjectEvent {
  final int projectId;

  const DeleteProjectEvent(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class ModifyProjectEvent extends ProjectEvent {
  final Project project;

  const ModifyProjectEvent(this.project);

  @override
  List<Object> get props => [project];
}
