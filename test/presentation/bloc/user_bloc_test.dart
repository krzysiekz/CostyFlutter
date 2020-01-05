import 'package:bloc_test/bloc_test.dart';
import 'package:costy/data/errors/failures.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/usecases/impl/add_user.dart';
import 'package:costy/data/usecases/impl/delete_user.dart';
import 'package:costy/data/usecases/impl/get_users.dart';
import 'package:costy/data/usecases/impl/modify_user.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockAddUser extends Mock implements AddUser {}

class MockDeleteUser extends Mock implements DeleteUser {}

class MockModifyUser extends Mock implements ModifyUser {}

void main() {
  MockGetUsers mockGetUsers;
  MockAddUser mockAddUser;
  MockDeleteUser mockDeleteUser;
  MockModifyUser mockModifyUser;

  UserBloc bloc;

  setUp(() {
    mockGetUsers = MockGetUsers();
    mockAddUser = MockAddUser();
    mockDeleteUser = MockDeleteUser();
    mockModifyUser = MockModifyUser();

    bloc = UserBloc(
        getUsers: mockGetUsers,
        addUser: mockAddUser,
        modifyUser: mockModifyUser,
        deleteUser: mockDeleteUser);
  });

  final tCreationDateTime = DateTime(2020, 1, 1, 10, 10, 10);
  final tProject = Project(
      id: 1,
      name: 'Test project',
      defaultCurrency: Currency(name: 'USD'),
      creationDateTime: tCreationDateTime);
  final tUsers = [
    User(id: 1, name: 'John'),
    User(id: 2, name: 'Kate'),
  ];

  blocTest('should emit empty state initially', build: () {
    return bloc;
  }, expect: [UserEmpty()]);

  blocTest('should emit proper states when getting users',
      build: () {
        when(mockGetUsers.call(any)).thenAnswer((_) async => Right(tUsers));
        return bloc;
      },
      act: (bloc) => bloc.add(GetUsersEvent(tProject)),
      expect: [UserEmpty(), UserLoading(), UserLoaded(tUsers)]);

  blocTest('should emit proper states in case of error when getting users',
      build: () {
        when(mockGetUsers.call(any))
            .thenAnswer((_) async => Left(DataSourceFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetUsersEvent(tProject)),
      expect: [
        UserEmpty(),
        UserLoading(),
        UserError(DATASOURCE_FAILURE_MESSAGE)
      ]);

  blocTest('should emit proper states when adding user',
      build: () {
        when(mockAddUser.call(any))
            .thenAnswer((_) async => Right(tUsers[0].id));
        return bloc;
      },
      act: (bloc) => bloc.add(AddUserEvent(tUsers[0].name, tProject)),
      expect: [UserEmpty(), UserLoading(), UserAdded(tUsers[0].id)]);

  blocTest('should emit proper states in case of error when adding user',
      build: () {
        when(mockAddUser.call(any))
            .thenAnswer((_) async => Left(DataSourceFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(AddUserEvent(tUsers[0].name, tProject)),
      expect: [
        UserEmpty(),
        UserLoading(),
        UserError(DATASOURCE_FAILURE_MESSAGE)
      ]);

  blocTest('should emit proper states when deleting user',
      build: () {
        when(mockDeleteUser.call(any))
            .thenAnswer((_) async => Right(tUsers[0].id));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteUserEvent(tUsers[0].id)),
      expect: [UserEmpty(), UserLoading(), UserDeleted(tUsers[0].id)]);

  blocTest('should emit proper states in case of error when deleting user',
      build: () {
        when(mockDeleteUser.call(any))
            .thenAnswer((_) async => Left(DataSourceFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteUserEvent(tUsers[0].id)),
      expect: [
        UserEmpty(),
        UserLoading(),
        UserError(DATASOURCE_FAILURE_MESSAGE)
      ]);

  blocTest('should emit proper states when modifying user',
      build: () {
        when(mockModifyUser.call(any))
            .thenAnswer((_) async => Right(tUsers[0].id));
        return bloc;
      },
      act: (bloc) => bloc.add(ModifyUserEvent(tUsers[0])),
      expect: [UserEmpty(), UserLoading(), UserModified(tUsers[0].id)]);

  blocTest('should emit proper states in case of error when modifying user',
      build: () {
        when(mockModifyUser.call(any))
            .thenAnswer((_) async => Left(DataSourceFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(ModifyUserEvent(tUsers[0])),
      expect: [
        UserEmpty(),
        UserLoading(),
        UserError(DATASOURCE_FAILURE_MESSAGE)
      ]);
}
