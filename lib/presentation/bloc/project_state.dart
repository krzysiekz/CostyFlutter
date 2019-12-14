import 'package:equatable/equatable.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();
}

class InitialProjectState extends ProjectState {
  @override
  List<Object> get props => [];
}
