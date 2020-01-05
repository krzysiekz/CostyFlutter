import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/repositories/users_repository.dart';
import 'package:costy/data/usecases/impl/get_users.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  GetUsers getUsers;
  MockUsersRepository mockUsersRepository;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    getUsers = GetUsers(usersRepository: mockUsersRepository);
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

  test('should get users for project', () async {
    //arrange
    when(mockUsersRepository.getUsers(any))
        .thenAnswer((_) async => Right(tUsers));
    //act
    final result = await getUsers.call(GetUsersParams(project: tProject));
    //assert
    expect(result, Right(tUsers));
    verify(mockUsersRepository.getUsers(tProject));
    verifyNoMoreInteractions(mockUsersRepository);
  });
}
