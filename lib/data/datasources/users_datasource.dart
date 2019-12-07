import '../models/project.dart';
import '../models/user.dart';

abstract class UsersDataSource {
  Future<List<User>> getUsers(Project project);

  Future<int> addUser({Project project, String name});

  Future<int> modifyUser(User user);

  Future<int> deleteUser(int userId);
}
