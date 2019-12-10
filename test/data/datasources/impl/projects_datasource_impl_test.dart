import 'dart:ffi';

import 'package:costy/data/datasources/entities/project_entity.dart';
import 'package:costy/data/datasources/hive_operations.dart';
import 'package:costy/data/datasources/impl/projects_datasource_impl.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

class MockHiveOperations extends Mock implements HiveOperations {}

class MockBox extends Mock implements Box {}

void main() {
  ProjectsDataSourceImpl dataSource;
  MockHiveOperations mockHiveOperations;
  MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    mockHiveOperations = MockHiveOperations();
    dataSource = ProjectsDataSourceImpl(mockHiveOperations);
  });

  final tProjectEntities = {
    1: ProjectEntity(name: 'First', defaultCurrency: 'USD'),
    2: ProjectEntity(name: 'Second', defaultCurrency: 'USD'),
  };

  final tProjectsList = [
    Project(id: 1, name: 'First', defaultCurrency: Currency(name: 'USD')),
    Project(id: 2, name: 'Second', defaultCurrency: Currency(name: 'USD'))
  ];

  test('should return list of projects', () async {
    //arrange
    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.toMap()).thenReturn(tProjectEntities);
    //act
    final projects = await dataSource.getProjects();
    //assert
    expect(projects, tProjectsList);

    verify(mockHiveOperations.openBox('projects'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.toMap());
    verifyNoMoreInteractions(mockBox);
  });

  test('should add project', () async {
    //arrange
    final tProjectId = 10;
    final tProjectName = 'new project';
    final tDefaultCurrency = Currency(name: 'USD');

    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.add(any)).thenAnswer((_) async => tProjectId);
    //act
    final result = await dataSource.addProject(tProjectName, tDefaultCurrency);
    //assert
    expect(result, tProjectId);

    verify(mockHiveOperations.openBox('projects'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.add(ProjectEntity(
        name: tProjectName, defaultCurrency: tDefaultCurrency.name)));
    verifyNoMoreInteractions(mockBox);
  });

  test('should delete project', () async {
    //arrange
    final tProjectId = 1;

    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.delete(any)).thenAnswer((_) async => Void());
    //act
    final result = await dataSource.deleteProject(tProjectId);
    //assert
    expect(result, tProjectId);

    verify(mockHiveOperations.openBox('projects'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.delete(tProjectId));
    verifyNoMoreInteractions(mockBox);
  });

  test('should modify project', () async {
    //arrange
    final tProject =
        Project(id: 5, name: 'First', defaultCurrency: Currency(name: 'USD'));

    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.put(any, any)).thenAnswer((_) async => Void());
    //act
    final result = await dataSource.modifyProject(tProject);
    //assert
    expect(result, tProject.id);

    verify(mockHiveOperations.openBox('projects'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.put(
        tProject.id,
        ProjectEntity(
            name: tProject.name,
            defaultCurrency: tProject.defaultCurrency.name)));
    verifyNoMoreInteractions(mockBox);
  });
}
