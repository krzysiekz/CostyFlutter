import 'package:costy/data/datasources/entities/project_entity.dart';
import 'package:costy/data/datasources/entities/user_entity.dart';
import 'package:costy/data/datasources/entities/user_expense_entity.dart';
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
  MockBox mockProjectsBox;
  MockBox mockExpensesBox;
  MockBox mockUsersBox;

  setUp(() {
    mockProjectsBox = MockBox();
    mockExpensesBox = MockBox();
    mockUsersBox = MockBox();
    mockHiveOperations = MockHiveOperations();
    dataSource = ProjectsDataSourceImpl(mockHiveOperations);
  });

  final tCreationDateTime = DateTime(2020, 1, 1, 10, 10, 10);

  final tProjectEntities = {
    1: ProjectEntity(
        name: 'First',
        defaultCurrency: 'USD',
        creationDateTime: tCreationDateTime.toIso8601String()),
    2: ProjectEntity(
        name: 'Second',
        defaultCurrency: 'USD',
        creationDateTime: tCreationDateTime.toIso8601String()),
  };

  final tProjectsList = [
    Project(
        id: 1,
        name: 'First',
        defaultCurrency: Currency(name: 'USD'),
        creationDateTime: tCreationDateTime),
    Project(
        id: 2,
        name: 'Second',
        defaultCurrency: Currency(name: 'USD'),
        creationDateTime: tCreationDateTime)
  ];

  test('should return list of projects', () async {
    //arrange
    when(mockHiveOperations.openBox(any))
        .thenAnswer((_) async => mockProjectsBox);
    when(mockProjectsBox.toMap()).thenReturn(tProjectEntities);
    //act
    final projects = await dataSource.getProjects();
    //assert
    expect(projects, tProjectsList);

    verify(mockHiveOperations.openBox('projects'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockProjectsBox.toMap());
    verifyNoMoreInteractions(mockProjectsBox);
  });

  test('should add project', () async {
    //arrange
    final tProjectId = 10;
    final tProjectName = 'new project';
    final tDefaultCurrency = Currency(name: 'USD');

    when(mockHiveOperations.openBox(any))
        .thenAnswer((_) async => mockProjectsBox);
    when(mockProjectsBox.add(any)).thenAnswer((_) async => tProjectId);
    //act
    final result = await dataSource.addProject(
        tProjectName, tDefaultCurrency, tCreationDateTime);
    //assert
    expect(result, tProjectId);

    verify(mockHiveOperations.openBox('projects'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockProjectsBox.add(ProjectEntity(
        name: tProjectName,
        defaultCurrency: tDefaultCurrency.name,
        creationDateTime: tCreationDateTime.toIso8601String())));
    verifyNoMoreInteractions(mockProjectsBox);
  });

  test('should delete project', () async {
    //arrange
    final tProjectId = 1;

    final tExpensesEntities = {
      1: UserExpenseEntity(
          projectId: tProjectId,
          amount: "10",
          currency: "USD",
          description: 'First Expense',
          userId: 1,
          receiversIds: [1, 2],
          dateTime: DateTime.now().toIso8601String()),
      2: UserExpenseEntity(
          projectId: tProjectId + 1,
          amount: "10",
          currency: "USD",
          description: 'First Expense',
          userId: 1,
          receiversIds: [1, 2],
          dateTime: DateTime.now().toIso8601String()),
    };

    final tUsersEntities = {
      1: UserEntity(name: 'John', projectId: tProjectId),
      2: UserEntity(name: 'Kate', projectId: tProjectId + 1),
    };

    when(mockHiveOperations.openBox("projects"))
        .thenAnswer((_) async => mockProjectsBox);
    when(mockHiveOperations.openBox("expenses"))
        .thenAnswer((_) async => mockExpensesBox);
    when(mockHiveOperations.openBox("users"))
        .thenAnswer((_) async => mockUsersBox);

    when(mockProjectsBox.delete(any)).thenAnswer((_) async => {});
    when(mockExpensesBox.delete(any)).thenAnswer((_) async => {});
    when(mockUsersBox.delete(any)).thenAnswer((_) async => {});

    when(mockExpensesBox.toMap()).thenReturn(tExpensesEntities);
    when(mockUsersBox.toMap()).thenReturn(tUsersEntities);
    //act
    final result = await dataSource.deleteProject(tProjectId);
    //assert
    expect(result, tProjectId);

    verify(mockHiveOperations.openBox('projects'));
    verify(mockHiveOperations.openBox('expenses'));
    verify(mockHiveOperations.openBox('users'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockExpensesBox.delete(1));
    verify(mockUsersBox.delete(1));
    verify(mockProjectsBox.delete(tProjectId));

    verifyNoMoreInteractions(mockProjectsBox);
  });

  test('should modify project', () async {
    //arrange
    final tProject = Project(
        id: 5,
        name: 'First',
        defaultCurrency: Currency(name: 'USD'),
        creationDateTime: tCreationDateTime);

    when(mockHiveOperations.openBox(any))
        .thenAnswer((_) async => mockProjectsBox);
    when(mockProjectsBox.put(any, any)).thenAnswer((_) async => {});
    //act
    final result = await dataSource.modifyProject(tProject);
    //assert
    expect(result, tProject.id);

    verify(mockHiveOperations.openBox('projects'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockProjectsBox.put(
        tProject.id,
        ProjectEntity(
            name: tProject.name,
            defaultCurrency: tProject.defaultCurrency.name,
            creationDateTime: tCreationDateTime.toIso8601String())));
    verifyNoMoreInteractions(mockProjectsBox);
  });
}
