import 'package:costy/data/repositories/projects_repository.dart';
import 'package:costy/data/usecases/impl/delete_project.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProjectsRepository extends Mock implements ProjectsRepository {}

void main() {
  DeleteProject deleteProject;
  MockProjectsRepository mockProjectsRepository;

  setUp(() {
    mockProjectsRepository = MockProjectsRepository();
    deleteProject = DeleteProject(projectsRepository: mockProjectsRepository);
  });

  const tProjectId = 1;

  test('should delete project using a repository', () async {
    //arrange
    when(mockProjectsRepository.deleteProject(any))
        .thenAnswer((_) async => const Right(tProjectId));
    //act
    final result = await deleteProject
        .call(const DeleteProjectParams(projectId: tProjectId));
    //assert
    expect(result, const Right(tProjectId));
    verify(mockProjectsRepository.deleteProject(tProjectId));
    verifyNoMoreInteractions(mockProjectsRepository);
  });
}
