import 'package:costy/data/datasources/expenses_datasource.dart';
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

void main() {
  ExpensesRepositoryImpl repository;
  MockExpensesDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockExpensesDataSource();
    repository = ExpensesRepositoryImpl(mockDataSource);
  });

  final john = User(id: 1, name: 'John');
  final kate = User(id: 2, name: 'Kate');

  final tProject = Project(
      id: 1, name: 'Test project', defaultCurrency: Currency(name: 'USD'));
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
    when(mockDataSource.addExpense(
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
    verify(mockDataSource.addExpense(
        project: tProject,
        amount: tAmount,
        currency: tCurrency,
        description: tDescription,
        user: john,
        receivers: tReceivers));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return failure when exception occurs during adding expense',
      () async {
    //arrange
    when(mockDataSource.addExpense(
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
    verify(mockDataSource.addExpense(
        project: tProject,
        amount: tAmount,
        currency: tCurrency,
        description: tDescription,
        user: john,
        receivers: tReceivers));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return object from data source when deleting expense', () async {
    //arrange
    when(mockDataSource.deleteExpense(any)).thenAnswer((_) async => tExpenseId);
    //act
    final result = await repository.deleteExpense(tExpenseId);
    //assert
    expect(result, Right(tExpenseId));
    verify(mockDataSource.deleteExpense(tExpenseId));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return failure when exception occurs during deleting expense',
      () async {
    //arrange
    when(mockDataSource.deleteExpense(any)).thenThrow(DataSourceException());
    //act
    final result = await repository.deleteExpense(tExpenseId);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.deleteExpense(tExpenseId));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return object from data source when getting expenses', () async {
    //arrange
    when(mockDataSource.getExpenses(any, any))
        .thenAnswer((_) async => tExpensesList);
    //act
    final result = await repository.getExpenses(tProject, [john, kate]);
    //assert
    expect(result, Right(tExpensesList));
    verify(mockDataSource.getExpenses(tProject, [john, kate]));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return failure when exception occurs during getting expenses',
      () async {
    //arrange
    when(mockDataSource.getExpenses(any, any)).thenThrow(DataSourceException());
    //act
    final result = await repository.getExpenses(tProject, [john, kate]);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.getExpenses(tProject, [john, kate]));
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return object from data source when modyfing expense', () async {
    //arrange
    when(mockDataSource.modifyExpense(any)).thenAnswer((_) async => tExpenseId);
    //act
    final result = await repository.modifyExpense(tExpensesList[0]);
    //assert
    expect(result, Right(tExpenseId));
    verify(mockDataSource.modifyExpense(tExpensesList[0]));
    verifyNoMoreInteractions(mockDataSource);
  });

  test(
      'should return failure when exception occurs during modification of expense',
      () async {
    //arrange
    when(mockDataSource.modifyExpense(any)).thenThrow(DataSourceException());
    //act
    final result = await repository.modifyExpense(tExpensesList[0]);
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.modifyExpense(tExpensesList[0]));
    verifyNoMoreInteractions(mockDataSource);
  });
}
