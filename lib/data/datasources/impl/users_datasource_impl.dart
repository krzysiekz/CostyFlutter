import 'package:costy/data/datasources/entities/user_entity.dart';

import '../../models/project.dart';
import '../../models/user.dart';
import '../hive_operations.dart';
import '../users_datasource.dart';

class UsersDataSourceImpl implements UsersDataSource {
  static const _BOX_NAME = 'users';

  final HiveOperations _hiveOperations;

  UsersDataSourceImpl(this._hiveOperations);

  @override
  Future<int> addUser({Project project, String name}) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    final entity = UserEntity(name: name, projectId: project.id);
    return box.add(entity);
  }

  @override
  Future<int> deleteUser(int userId) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    await box.delete(userId);
    return userId;
  }

  @override
  Future<List<User>> getUsers(Project project) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    final entityMap = box.toMap();
    return entityMap.entries
        .where((e) => (e.value as UserEntity).projectId == project.id)
        .map(_mapEntityToUser)
        .toList();
  }

  @override
  Future<int> modifyUser(User user) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    final oldUserEntity = box.get(user.id) as UserEntity;
    if (oldUserEntity != null) {
      final newUserEntity =
          UserEntity(name: user.name, projectId: oldUserEntity.projectId);
      await box.put(user.id, newUserEntity);
    }
    return user.id;
  }

  User _mapEntityToUser(e) =>
      User(id: e.key, name: (e.value as UserEntity).name);
}
