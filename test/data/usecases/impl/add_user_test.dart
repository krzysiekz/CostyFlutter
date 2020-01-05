import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/repositories/users_repository.dart';
import 'package:costy/data/usecases/impl/add_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  AddUser addUser;
  MockUsersRepository mockUsersRepository;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    addUser = AddUser(usersRepository: mockUsersRepository);
  });

  final tCreationDateTime = DateTime(2020, 1, 1, 10, 10, 10);
  final tProject = Project(
      id: 1,
      name: 'Test project',
      defaultCurrency: Currency(name: 'USD'),
      creationDateTime: tCreationDateTime);
  final tName = 'John';
  final tUserId = 1;

  test('should add user to project', () async {
    //arrange
    when(mockUsersRepository.addUser(
            project: anyNamed('project'), name: anyNamed('name')))
        .thenAnswer((_) async => Right(tUserId));
    //act
    final result =
        await addUser.call(AddUserParams(project: tProject, name: tName));
    //assert
    expect(result, Right(tUserId));
    verify(mockUsersRepository.addUser(project: tProject, name: tName));
    verifyNoMoreInteractions(mockUsersRepository);
  });
}
