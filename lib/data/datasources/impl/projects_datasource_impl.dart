import 'package:injectable/injectable.dart';

import '../../../injection.dart';
import '../../models/currency.dart';
import '../../models/project.dart';
import '../entities/project_entity.dart';
import '../entities/user_entity.dart';
import '../entities/user_expense_entity.dart';
import '../hive_operations.dart';
import '../projects_datasource.dart';
import 'expenses_datasource_impl.dart';
import 'users_datasource_impl.dart';

@Singleton(as: ProjectsDataSource, env: [Env.prod])
class ProjectsDataSourceImpl implements ProjectsDataSource {
  static const _BOX_NAME = 'projects';
  final HiveOperations _hiveOperations;

  ProjectsDataSourceImpl(this._hiveOperations);

  @override
  Future<int> addProject(
    String projectName,
    Currency defaultCurrency,
    DateTime creationDateTime,
  ) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    final entity = ProjectEntity(
      name: projectName,
      defaultCurrency: defaultCurrency.name,
      creationDateTime: creationDateTime.toIso8601String(),
    );
    return box.add(entity);
  }

  @override
  Future<int> deleteProject(int projectId) async {
    await deleteExpenses(projectId);
    await deleteUsers(projectId);

    final box = await _hiveOperations.openBox(_BOX_NAME);
    await box.delete(projectId);
    return projectId;
  }

  Future deleteExpenses(int projectId) async {
    final expensesBox =
        await _hiveOperations.openBox(ExpensesDataSourceImpl.BOX_NAME);
    final entityMap = expensesBox.toMap();
    entityMap.entries
        .where((e) => (e.value as UserExpenseEntity).projectId == projectId)
        .forEach((e) => expensesBox.delete(e.key));
  }

  Future deleteUsers(int projectId) async {
    final usersBox =
        await _hiveOperations.openBox(UsersDataSourceImpl.BOX_NAME);
    final entityMap = usersBox.toMap();
    entityMap.entries
        .where((e) => (e.value as UserEntity).projectId == projectId)
        .forEach((e) => usersBox.delete(e.key));
  }

  @override
  Future<List<Project>> getProjects() async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    final entityMap = box.toMap();
    return entityMap.entries.map(_mapEntityToProject).toList();
  }

  @override
  Future<int> modifyProject(Project project) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    final newProjectEntity = ProjectEntity(
      name: project.name,
      defaultCurrency: project.defaultCurrency.name,
      creationDateTime: project.creationDateTime.toIso8601String(),
    );
    await box.put(project.id, newProjectEntity);
    return project.id;
  }

  Project _mapEntityToProject(e) => Project(
      id: e.key,
      name: (e.value as ProjectEntity).name,
      defaultCurrency:
          Currency(name: (e.value as ProjectEntity).defaultCurrency),
      creationDateTime:
          DateTime.parse((e.value as ProjectEntity).creationDateTime));
}
