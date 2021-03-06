import 'package:costy/data/datasources/projects_datasource.dart';
import 'package:costy/data/errors/exceptions.dart';
import 'package:costy/data/errors/failures.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/repositories/impl/projects_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProjectsDataSource extends Mock implements ProjectsDataSource {}

void main() {
  ProjectsRepositoryImpl repository;
  MockProjectsDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockProjectsDataSource();
    repository = ProjectsRepositoryImpl(mockDataSource);
  });

  const tProjectName = 'Sample project.';
  const tProjectDefaultCurrency = Currency(name: 'USD');
  const tProjectId = 1;
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

  test('should return object from data source when adding project', () async {
    //arrange
    when(mockDataSource.addProject(any, any, any))
        .thenAnswer((_) async => tProjectId);
    //act
    final result = await repository.addProject(
        tProjectName, tProjectDefaultCurrency, tCreationDateTime);
    //assert
    expect(result, const Right(tProjectId));
    verify(mockDataSource.addProject(
        tProjectName, tProjectDefaultCurrency, tCreationDateTime));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return failure when exception occurs during adding project',
      () async {
    //arrange
    when(mockDataSource.addProject(any, any, any))
        .thenThrow(DataSourceException());
    //act
    final result = await repository.addProject(
        tProjectName, tProjectDefaultCurrency, tCreationDateTime);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.addProject(
        tProjectName, tProjectDefaultCurrency, tCreationDateTime));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return object from data source when deleting project', () async {
    //arrange
    when(mockDataSource.deleteProject(any)).thenAnswer((_) async => tProjectId);
    //act
    final result = await repository.deleteProject(tProjectId);
    //assert
    expect(result, const Right(tProjectId));
    verify(mockDataSource.deleteProject(tProjectId));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return failure when exception occurs during deleting project',
      () async {
    //arrange
    when(mockDataSource.deleteProject(any)).thenThrow(DataSourceException());
    //act
    final result = await repository.deleteProject(tProjectId);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.deleteProject(tProjectId));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return object from data source when getting projects', () async {
    //arrange
    when(mockDataSource.getProjects()).thenAnswer((_) async => tProjectsList);
    //act
    final result = await repository.getProjects();
    //assert
    expect(result, Right(tProjectsList));
    verify(mockDataSource.getProjects());
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return failure when exception occurs during getting projects',
      () async {
    //arrange
    when(mockDataSource.getProjects()).thenThrow(DataSourceException());
    //act
    final result = await repository.getProjects();
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.getProjects());
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return object from data source when modyfing project', () async {
    //arrange
    when(mockDataSource.modifyProject(any)).thenAnswer((_) async => tProjectId);
    //act
    final result = await repository.modifyProject(tProjectsList[0]);
    //assert
    expect(result, const Right(tProjectId));
    verify(mockDataSource.modifyProject(tProjectsList[0]));
    verifyNoMoreInteractions(mockDataSource);
  });

  test(
      'should return failure when exception occurs during modification of project',
      () async {
    //arrange
    when(mockDataSource.modifyProject(any)).thenThrow(DataSourceException());
    //act
    final result = await repository.modifyProject(tProjectsList[0]);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.modifyProject(tProjectsList[0]));
    verifyNoMoreInteractions(mockDataSource);
  });
}
