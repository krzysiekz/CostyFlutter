import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/repositories/projects_repository.dart';
import 'package:costy/data/usecases/impl/get_projects.dart';
import 'package:costy/data/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProjectsRepository extends Mock implements ProjectsRepository {}

void main() {
  GetProjects getProjects;
  MockProjectsRepository mockProjectsRepository;

  setUp(() {
    mockProjectsRepository = MockProjectsRepository();
    getProjects = GetProjects(projectsRepository: mockProjectsRepository);
  });

  final tCreationDateTime = DateTime(2020, 1, 1, 10, 10, 10);
  final tProjectsList = [
    Project(
        id: 1,
        name: 'First',
        defaultCurrency: const Currency(name: 'USD'),
        creationDateTime: tCreationDateTime),
    Project(
        id: 2,
        name: 'Second',
        defaultCurrency: const Currency(name: 'USD'),
        creationDateTime: tCreationDateTime)
  ];

  test('should get projects from the repository', () async {
    //arrange
    when(mockProjectsRepository.getProjects())
        .thenAnswer((_) async => Right(tProjectsList));
    //act
    final result = await getProjects.call(NoParams());
    //assert
    expect(result, Right(tProjectsList));
    verify(mockProjectsRepository.getProjects());
    verifyNoMoreInteractions(mockProjectsRepository);
  });
}
