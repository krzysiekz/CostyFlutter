import 'package:equatable/equatable.dart';

import '../../data/models/project.dart';
import '../../data/models/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class GetUsersEvent extends UserEvent {
  final Project project;

  const GetUsersEvent(this.project);

  @override
  List<Object> get props => [project];
}

class DeleteUserEvent extends UserEvent {
  final int userId;

  const DeleteUserEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddUserEvent extends UserEvent {
  final String name;
  final Project project;

  const AddUserEvent(this.name, this.project);

  @override
  List<Object> get props => [name];
}

class ModifyUserEvent extends UserEvent {
  final User user;

  const ModifyUserEvent(this.user);

  @override
  List<Object> get props => [user];
}
