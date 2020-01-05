import '../models/currency.dart';
import '../models/project.dart';

abstract class ProjectsDataSource {
  Future<List<Project>> getProjects();

  Future<int> addProject(
    String projectName,
    Currency defaultCurrency,
    DateTime creationDateTime,
  );

  Future<int> deleteProject(int projectId);

  Future<int> modifyProject(Project project);
}
