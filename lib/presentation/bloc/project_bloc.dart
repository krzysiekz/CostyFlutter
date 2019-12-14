import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  @override
  ProjectState get initialState => InitialProjectState();

  @override
  Stream<ProjectState> mapEventToState(
    ProjectEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
