import '../../models/currency.dart';
import '../../models/project.dart';
import '../entities/project_entity.dart';
import '../hive_operations.dart';
import '../projects_datasource.dart';

class ProjectsDataSourceImpl implements ProjectsDataSource {
  static const _BOX_NAME = 'projects';
  final HiveOperations _hiveOperations;

  ProjectsDataSourceImpl(this._hiveOperations);

  @override
  Future<int> addProject(String projectName, Currency defaultCurrency) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    final entity =
        ProjectEntity(name: projectName, defaultCurrency: defaultCurrency.name);
    return box.add(entity);
  }

  @override
  Future<int> deleteProject(int projectId) async {
    final box = await _hiveOperations.openBox(_BOX_NAME);
    await box.delete(projectId);
    return projectId;
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
        name: project.name, defaultCurrency: project.defaultCurrency.name);
    await box.put(project.id, newProjectEntity);
    return project.id;
  }

  Project _mapEntityToProject(e) => Project(
      id: e.key,
      name: (e.value as ProjectEntity).name,
      defaultCurrency:
          Currency(name: (e.value as ProjectEntity).defaultCurrency));
}
