import 'package:costy/data/datasources/expenses_datasource.dart';
import 'package:costy/data/datasources/users_datasource.dart';
import 'package:costy/data/errors/exceptions.dart';
import 'package:costy/data/errors/failures.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/data/repositories/impl/expenses_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockExpensesDataSource extends Mock implements ExpensesDataSource {}

class MockUsersDataSource extends Mock implements UsersDataSource {}

void main() {
  ExpensesRepositoryImpl repository;
  MockExpensesDataSource mockExpensesDataSource;
  MockUsersDataSource mockUsersDataSource;

  setUp(() {
    mockExpensesDataSource = MockExpensesDataSource();
    mockUsersDataSource = MockUsersDataSource();
    repository =
        ExpensesRepositoryImpl(mockExpensesDataSource, mockUsersDataSource);
  });

  final john = User(id: 1, name: 'John');
  final kate = User(id: 2, name: 'Kate');

  final tCreationDateTime = DateTime(2020, 1, 1, 10, 10, 10);
  final tProject = Project(
      id: 1,
      name: 'Test project',
      defaultCurrency: Currency(name: 'USD'),
      creationDateTime: tCreationDateTime);
  final tAmount = Decimal.fromInt(10);
  final tCurrency = Currency(name: 'USD');
  final tDescription = 'First Expense';
  final tReceivers = [john, kate];
  final tExpenseId = 1;

  final tExpensesList = [
    UserExpense(
        id: 1,
        amount: Decimal.fromInt(10),
        currency: tCurrency,
        description: 'First Expense',
        user: john,
        receivers: [john, kate]),
    UserExpense(
        id: 2,
        amount: Decimal.fromInt(20),
        currency: tCurrency,
        description: 'Second Expense',
        user: kate,
        receivers: [john, kate]),
  ];

  test('should return object from data source when adding expense', () async {
    //arrange
    when(mockExpensesDataSource.addExpense(
            project: anyNamed('project'),
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            description: anyNamed('description'),
            user: anyNamed('user'),
            receivers: anyNamed('receivers')))
        .thenAnswer((_) async => tExpenseId);
    //act
    final result = await repository.addExpense(
        project: tProject,
        amount: tAmount,
        currency: tCurrency,
        description: tDescription,
        user: john,
        receivers: tReceivers);
    //assert
    expect(result, Right(tExpenseId));
    verify(mockExpensesDataSource.addExpense(
        project: tProject,
        amount: tAmount,
        currency: tCurrency,
        description: tDescription,
        user: john,
        receivers: tReceivers));
    verifyNoMoreInteractions(mockExpensesDataSource);
  });

  test('should return failure when exception occurs during adding expense',
      () async {
    //arrange
    when(mockExpensesDataSource.addExpense(
            project: anyNamed('project'),
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            description: anyNamed('description'),
            user: anyNamed('user'),
            receivers: anyNamed('receivers')))
        .thenThrow(DataSourceException());
    //act
    final result = await repository.addExpense(
        project: tProject,
        amount: tAmount,
        currency: tCurrency,
        description: tDescription,
        user: john,
        receivers: tReceivers);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockExpensesDataSource.addExpense(
        project: tProject,
        amount: tAmount,
        currency: tCurrency,
        description: tDescription,
        user: john,
        receivers: tReceivers));
    verifyNoMoreInteractions(mockExpensesDataSource);
  });

  test('should return object from data source when deleting expense', () async {
    //arrange
    when(mockExpensesDataSource.deleteExpense(any))
        .thenAnswer((_) async => tExpenseId);
    //act
    final result = await repository.deleteExpense(tExpenseId);
    //assert
    expect(result, Right(tExpenseId));
    verify(mockExpensesDataSource.deleteExpense(tExpenseId));
    verifyNoMoreInteractions(mockExpensesDataSource);
  });

  test('should return failure when exception occurs during deleting expense',
      () async {
    //arrange
    when(mockExpensesDataSource.deleteExpense(any))
        .thenThrow(DataSourceException());
    //act
    final result = await repository.deleteExpense(tExpenseId);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockExpensesDataSource.deleteExpense(tExpenseId));
    verifyNoMoreInteractions(mockExpensesDataSource);
  });

  test('should return object from data source when getting expenses', () async {
    //arrange
    when(mockExpensesDataSource.getExpenses(any, any))
        .thenAnswer((_) async => tExpensesList);
    when(mockUsersDataSource.getUsers(any))
        .thenAnswer((_) async => [john, kate]);
    //act
    final result = await repository.getExpenses(tProject);
    //assert
    expect(result, Right(tExpensesList));
    verify(mockExpensesDataSource.getExpenses(tProject, [john, kate]));
    verify(mockUsersDataSource.getUsers(tProject));
    verifyNoMoreInteractions(mockExpensesDataSource);
  });

  test('should return failure when exception occurs during getting expenses',
      () async {
    //arrange
    when(mockExpensesDataSource.getExpenses(any, any))
        .thenThrow(DataSourceException());
    when(mockUsersDataSource.getUsers(any))
        .thenAnswer((_) async => [john, kate]);
    //act
    final result = await repository.getExpenses(tProject);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockExpensesDataSource.getExpenses(tProject, [john, kate]));
    verify(mockUsersDataSource.getUsers(tProject));
    verifyNoMoreInteractions(mockExpensesDataSource);
  });

  test('should return object from data source when modyfing expense', () async {
    //arrange
    when(mockExpensesDataSource.modifyExpense(any))
        .thenAnswer((_) async => tExpenseId);
    //act
    final result = await repository.modifyExpense(tExpensesList[0]);
    //assert
    expect(result, Right(tExpenseId));
    verify(mockExpensesDataSource.modifyExpense(tExpensesList[0]));
    verifyNoMoreInteractions(mockExpensesDataSource);
  });

  test(
      'should return failure when exception occurs during modification of expense',
      () async {
    //arrange
    when(mockExpensesDataSource.modifyExpense(any))
        .thenThrow(DataSourceException());
    //act
    final result = await repository.modifyExpense(tExpensesList[0]);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockExpensesDataSource.modifyExpense(tExpensesList[0]));
    verifyNoMoreInteractions(mockExpensesDataSource);
  });
}
