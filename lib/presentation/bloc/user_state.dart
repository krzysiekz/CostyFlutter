import 'package:equatable/equatable.dart';

import '../../data/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserEmpty extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final List<User> users;

  const UserLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserAdded extends UserState {
  final int userId;

  const UserAdded(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserDeleted extends UserState {
  final int userId;

  const UserDeleted(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserModified extends UserState {
  final int userId;

  const UserModified(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserError extends UserState {
  final String errorMessage;

  const UserError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
