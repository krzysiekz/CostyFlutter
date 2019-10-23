import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/repositories/users_repository.dart';
import 'package:costy/data/usecases/impl/get_users_for_project.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  GetUsersForProject getUsersForProject;
  MockUsersRepository mockUsersRepository;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    getUsersForProject =
        GetUsersForProject(usersRepository: mockUsersRepository);
  });

  final tProject = Project(
      id: 1, name: 'Test project', defaultCurrency: Currency(name: 'USD'));
  final tUsers = [
    User(id: 1, name: 'John'),
    User(id: 2, name: 'Kate'),
  ];

  test('should get users for project', () async {
    //arrange
    when(mockUsersRepository.getUsers(any))
        .thenAnswer((_) async => Right(tUsers));
    //act
    final result = await getUsersForProject.call(Params(project: tProject));
    //assert
    expect(result, Right(tUsers));
    verify(mockUsersRepository.getUsers(tProject));
    verifyNoMoreInteractions(mockUsersRepository);
  });
}
