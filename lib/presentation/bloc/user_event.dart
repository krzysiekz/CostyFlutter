import 'package:equatable/equatable.dart';

import '../../data/models/project.dart';
import '../../data/models/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class GetUsersEvent extends UserEvent {
  final Project project;

  GetUsersEvent(this.project);

  @override
  List<Object> get props => [project];
}

class DeleteUserEvent extends UserEvent {
  final int userId;

  DeleteUserEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddUserEvent extends UserEvent {
  final String name;
  final Project project;

  AddUserEvent(this.name, this.project);

  @override
  List<Object> get props => [this.name];
}

class ModifyUserEvent extends UserEvent {
  final User user;

  ModifyUserEvent(this.user);

  @override
  List<Object> get props => [user];
}
