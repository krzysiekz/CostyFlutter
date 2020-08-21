import 'package:costy/data/repositories/users_repository.dart';
import 'package:costy/data/usecases/impl/delete_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  DeleteUser deleteUser;
  MockUsersRepository mockUsersRepository;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    deleteUser = DeleteUser(usersRepository: mockUsersRepository);
  });

  const tUserId = 1;

  test('should delete user', () async {
    //arrange
    when(mockUsersRepository.deleteUser(any))
        .thenAnswer((_) async => const Right(tUserId));
    //act
    final result =
        await deleteUser.call(const DeleteUserParams(userId: tUserId));
    //assert
    expect(result, const Right(tUserId));
    verify(mockUsersRepository.deleteUser(tUserId));
    verifyNoMoreInteractions(mockUsersRepository);
  });
}
