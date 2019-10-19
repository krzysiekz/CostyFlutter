import 'package:costy/data/models/currency.dart';
import 'package:costy/data/repositories/projects_repository.dart';
import 'package:costy/data/usecases/impl/add_project.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProjectsRepository extends Mock implements ProjectsRepository {}

void main() {
  AddProject addProject;
  MockProjectsRepository mockProjectsRepository;

  setUp(() {
    mockProjectsRepository = MockProjectsRepository();
    addProject = AddProject(projectsRepository: mockProjectsRepository);
  });

  final tProjectName = 'Sample project.';
  final tProjectDefaultCurrency = Currency(name: 'USD');
  final tProjectId = 1;

  test('should add project using a repository', () async {
    //arrange
    when(mockProjectsRepository.addProject(any, any))
        .thenAnswer((_) async => Right(tProjectId));
    //act
    final result = await addProject.call(Params(
        projectName: tProjectName, defaultCurrency: tProjectDefaultCurrency));
    //assert
    expect(result, Right(tProjectId));
    verify(mockProjectsRepository.addProject(
        tProjectName, tProjectDefaultCurrency));
    verifyNoMoreInteractions(mockProjectsRepository);
  });
}
