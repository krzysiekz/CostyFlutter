import 'package:costy/data/models/user.dart';
import 'package:costy/data/repositories/users_repository.dart';
import 'package:costy/data/usecases/impl/modify_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  ModifyUser modifyUser;
  MockUsersRepository mockUsersRepository;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    modifyUser = ModifyUser(usersRepository: mockUsersRepository);
  });

  const tUser = User(id: 1, name: 'John');

  test('should modify user', () async {
    //arrange
    when(mockUsersRepository.modifyUser(tUser))
        .thenAnswer((_) async => Right(tUser.id));
    //act
    final result = await modifyUser.call(const ModifyUserParams(user: tUser));
    //assert
    expect(result, Right(tUser.id));
    verify(mockUsersRepository.modifyUser(tUser));
    verifyNoMoreInteractions(mockUsersRepository);
  });
}
