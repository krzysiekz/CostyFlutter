import 'package:costy/data/models/currency.dart';
import 'package:costy/data/repositories/projects_repository.dart';
import 'package:costy/data/usecases/impl/modify_project.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProjectsRepository extends Mock implements ProjectsRepository {}

void main() {
  ModifyProject modifyProject;
  MockProjectsRepository mockProjectsRepository;

  setUp(() {
    mockProjectsRepository = MockProjectsRepository();
    modifyProject = ModifyProject(projectsRepository: mockProjectsRepository);
  });

  final tProjectName = 'Sample project.';
  final tProjectDefaultCurrency = Currency(name: 'USD');
  final tProjectId = 1;

  test('should modify project using a repository', () async {
    //arrange
    when(mockProjectsRepository.modifyProject(any, any))
        .thenAnswer((_) async => Right(tProjectId));
    //act
    final result = await modifyProject.call(Params(
        projectName: tProjectName, defaultCurrency: tProjectDefaultCurrency));
    //assert
    expect(result, Right(tProjectId));
    verify(mockProjectsRepository.modifyProject(
        tProjectName, tProjectDefaultCurrency));
    verifyNoMoreInteractions(mockProjectsRepository);
  });
}
