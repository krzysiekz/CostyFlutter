import 'package:costy/data/datasources/entities/user_entity.dart';
import 'package:costy/data/datasources/hive_operations.dart';
import 'package:costy/data/datasources/impl/users_datasource_impl.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

class MockHiveOperations extends Mock implements HiveOperations {}

class MockBox extends Mock implements Box {}

void main() {
  UsersDataSourceImpl dataSource;
  MockHiveOperations mockHiveOperations;
  MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    mockHiveOperations = MockHiveOperations();
    dataSource = UsersDataSourceImpl(mockHiveOperations);
  });

  final tProject = Project(
      id: 1, name: 'Test project', defaultCurrency: Currency(name: 'USD'));

  final tUsers = [
    User(id: 1, name: 'John'),
    User(id: 2, name: 'Kate'),
  ];

  final tUsersEntities = {
    1: UserEntity(name: 'John', projectId: 1),
    2: UserEntity(name: 'Kate', projectId: 1),
  };

  final tUserId = 1;

  test('should return list of users', () async {
    //arrange
    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.toMap()).thenReturn(tUsersEntities);
    //act
    final users = await dataSource.getUsers(tProject);
    //assert
    expect(users, tUsers);

    verify(mockHiveOperations.openBox('users'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.toMap());
    verifyNoMoreInteractions(mockBox);
  });

  test('should add user', () async {
    //arrange
    final tName = 'John';

    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.add(any)).thenAnswer((_) async => tUserId);
    //act
    final result = await dataSource.addUser(project: tProject, name: tName);
    //assert
    expect(result, tUserId);

    verify(mockHiveOperations.openBox('users'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.add(UserEntity(name: tName, projectId: tProject.id)));
    verifyNoMoreInteractions(mockBox);
  });

  test('should delete user', () async {
    //arrange
    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.delete(any)).thenAnswer((_) async => {});
    //act
    final result = await dataSource.deleteUser(tUserId);
    //assert
    expect(result, tUserId);

    verify(mockHiveOperations.openBox('users'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.delete(tUserId));
    verifyNoMoreInteractions(mockBox);
  });

  test('should modify user', () async {
    //arrange
    final tUser = User(id: 1, name: 'First');

    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.get(any)).thenReturn(tUsersEntities[1]);
    when(mockBox.put(any, any)).thenAnswer((_) async => {});
    //act
    final result = await dataSource.modifyUser(tUser);
    //assert
    expect(result, tUser.id);

    verify(mockHiveOperations.openBox('users'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.get(tUser.id));
    verify(mockBox.put(
        tUser.id, UserEntity(name: tUser.name, projectId: tProject.id)));
    verifyNoMoreInteractions(mockBox);
  });
}
