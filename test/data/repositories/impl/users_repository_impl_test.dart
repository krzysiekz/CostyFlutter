import 'package:costy/data/datasources/users_datasource.dart';
import 'package:costy/data/errors/exceptions.dart';
import 'package:costy/data/errors/failures.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/repositories/impl/users_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUsersDataSource extends Mock implements UsersDataSource {}

void main() {
  UsersRepositoryImpl repository;
  MockUsersDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockUsersDataSource();
    repository = UsersRepositoryImpl(mockDataSource);
  });

  final tProject = Project(
      id: 1, name: 'Test project', defaultCurrency: Currency(name: 'USD'));
  final tName = 'John';
  final tUserId = 1;
  final tUsers = [
    User(id: 1, name: 'John'),
    User(id: 2, name: 'Kate'),
  ];

  test('should return object from data source when adding user', () async {
    //arrange
    when(mockDataSource.addUser(
            project: anyNamed('project'), name: anyNamed('name')))
        .thenAnswer((_) async => tUserId);
    //act
    final result = await repository.addUser(project: tProject, name: tName);
    //assert
    expect(result, Right(tUserId));
    verify(mockDataSource.addUser(project: tProject, name: tName));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return failure when exception occurs during adding user',
      () async {
    //arrange
    when(mockDataSource.addUser(
            project: anyNamed('project'), name: anyNamed('name')))
        .thenThrow(DataSourceException());
    //act
    final result = await repository.addUser(project: tProject, name: tName);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.addUser(project: tProject, name: tName));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return object from data source when deleting user', () async {
    //arrange
    when(mockDataSource.deleteUser(any)).thenAnswer((_) async => tUserId);
    //act
    final result = await repository.deleteUser(tUserId);
    //assert
    expect(result, Right(tUserId));
    verify(mockDataSource.deleteUser(tUserId));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return failure when exception occurs during deleting user',
      () async {
    //arrange
    when(mockDataSource.deleteUser(any)).thenThrow(DataSourceException());
    //act
    final result = await repository.deleteUser(tUserId);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.deleteUser(tUserId));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return object from data source when getting users', () async {
    //arrange
    when(mockDataSource.getUsers(any)).thenAnswer((_) async => tUsers);
    //act
    final result = await repository.getUsers(tProject);
    //assert
    expect(result, Right(tUsers));
    verify(mockDataSource.getUsers(tProject));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return failure when exception occurs during getting users',
      () async {
    //arrange
    when(mockDataSource.getUsers(any)).thenThrow(DataSourceException());
    //act
    final result = await repository.getUsers(tProject);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.getUsers(tProject));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return object from data source when modyfing user', () async {
    //arrange
    when(mockDataSource.modifyUser(any)).thenAnswer((_) async => tUserId);
    //act
    final result = await repository.modifyUser(tUsers[0]);
    //assert
    expect(result, Right(tUserId));
    verify(mockDataSource.modifyUser(tUsers[0]));
    verifyNoMoreInteractions(mockDataSource);
  });

  test(
      'should return failure when exception occurs during modification of user',
      () async {
    //arrange
    when(mockDataSource.modifyUser(any)).thenThrow(DataSourceException());
    //act
    final result = await repository.modifyUser(tUsers[0]);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.modifyUser(tUsers[0]));
    verifyNoMoreInteractions(mockDataSource);
  });
}
