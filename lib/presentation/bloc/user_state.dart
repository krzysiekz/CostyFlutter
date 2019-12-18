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

  UserLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserAdded extends UserState {
  final int userId;

  UserAdded(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserDeleted extends UserState {
  final int userId;

  UserDeleted(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserModified extends UserState {
  final int userId;

  UserModified(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserError extends UserState {
  final String errorMessage;

  UserError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
