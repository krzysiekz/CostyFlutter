import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';
import '../../data/usecases/impl/add_user.dart';
import '../../data/usecases/impl/delete_user.dart';
import '../../data/usecases/impl/get_users.dart';
import '../../data/usecases/impl/modify_user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final AddUser addUser;
  final ModifyUser modifyUser;
  final DeleteUser deleteUser;

  UserBloc({this.getUsers, this.addUser, this.modifyUser, this.deleteUser})
      : super(UserEmpty());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is GetUsersEvent) {
      yield* _processGetUsersEvent(event);
    } else if (event is AddUserEvent) {
      yield* _processAddUserEvent(event);
    } else if (event is DeleteUserEvent) {
      yield* _processDeleteUserEvent(event);
    } else if (event is ModifyUserEvent) {
      yield* _processModifyUserEvent(event);
    }
  }

  Stream<UserState> _processGetUsersEvent(GetUsersEvent event) async* {
    yield UserLoading();
    final dataOrFailure =
        await getUsers.call(GetUsersParams(project: event.project));
    yield dataOrFailure.fold(
      (failure) => UserError(mapFailureToMessage(failure)),
      (users) => UserLoaded(users),
    );
  }

  Stream<UserState> _processAddUserEvent(AddUserEvent event) async* {
    yield UserLoading();
    final dataOrFailure = await addUser
        .call(AddUserParams(project: event.project, name: event.name));
    yield dataOrFailure.fold(
      (failure) => UserError(mapFailureToMessage(failure)),
      (userId) => UserAdded(userId),
    );
  }

  Stream<UserState> _processDeleteUserEvent(DeleteUserEvent event) async* {
    yield UserLoading();
    final dataOrFailure =
        await deleteUser.call(DeleteUserParams(userId: event.userId));
    yield dataOrFailure.fold(
      (failure) => UserError(mapFailureToMessage(failure)),
      (userId) => UserDeleted(userId),
    );
  }

  Stream<UserState> _processModifyUserEvent(ModifyUserEvent event) async* {
    yield UserLoading();
    final dataOrFailure =
        await modifyUser.call(ModifyUserParams(user: event.user));
    yield dataOrFailure.fold(
      (failure) => UserError(mapFailureToMessage(failure)),
      (userId) => UserModified(userId),
    );
  }
}
