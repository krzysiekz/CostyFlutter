import 'dart:ffi';

import 'package:costy/data/datasources/entities/user_entity.dart';
import 'package:costy/data/datasources/entities/user_expense_entity.dart';
import 'package:costy/data/datasources/hive_operations.dart';
import 'package:costy/data/datasources/impl/expenses_datasource_impl.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

class MockHiveOperations extends Mock implements HiveOperations {}

class MockBox extends Mock implements Box {}

void main() {
  ExpensesDataSourceImpl dataSource;
  MockHiveOperations mockHiveOperations;
  MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    mockHiveOperations = MockHiveOperations();
    dataSource = ExpensesDataSourceImpl(mockHiveOperations);
  });

  final john = User(id: 1, name: 'John');
  final kate = User(id: 2, name: 'Kate');

  final tProject = Project(
      id: 1, name: 'Test project', defaultCurrency: Currency(name: 'USD'));
  final tAmount = Decimal.fromInt(10);
  final tCurrency = Currency(name: 'USD');
  final tDescription = 'First Expense';
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

  final tExpensesEntities = {
    1: UserExpenseEntity(
        projectId: tProject.id,
        amount: Decimal.fromInt(10),
        currency: tCurrency.name,
        description: 'First Expense',
        userId: john.id,
        receiversIds: [john.id, kate.id]),
    2: UserExpenseEntity(
        projectId: tProject.id,
        amount: Decimal.fromInt(20),
        currency: tCurrency.name,
        description: 'Second Expense',
        userId: kate.id,
        receiversIds: [john.id, kate.id]),
  };

  test('should return list of expenses', () async {
    //arrange
    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.toMap()).thenReturn(tExpensesEntities);
    //act
    final expenses = await dataSource.getExpenses(tProject, [john, kate]);
    //assert
    expect(expenses, tExpensesList);

    verify(mockHiveOperations.openBox('expenses'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.toMap());
    verifyNoMoreInteractions(mockBox);
  });

  test('should add expense', () async {
    //arrange
    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.add(any)).thenAnswer((_) async => tExpenseId);
    //act
    final result = await dataSource.addExpense(
        project: tProject,
        receivers: [john, kate],
        user: john,
        currency: tCurrency,
        amount: tAmount,
        description: tDescription);
    //assert
    expect(result, tExpenseId);

    verify(mockHiveOperations.openBox('expenses'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.add(UserExpenseEntity(
      userId: john.id,
      projectId: tProject.id,
      amount: tAmount,
      currency: tCurrency.name,
      description: tDescription,
      receiversIds: [john.id, kate.id],
    )));
    verifyNoMoreInteractions(mockBox);
  });

  test('should delete expense', () async {
    //arrange
    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.delete(any)).thenAnswer((_) async => Void());
    //act
    final result = await dataSource.deleteExpense(tExpenseId);
    //assert
    expect(result, tExpenseId);

    verify(mockHiveOperations.openBox('expenses'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.delete(tExpenseId));
    verifyNoMoreInteractions(mockBox);
  });

  test('should modify expense', () async {
    //arrange
    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.get(any)).thenReturn(tExpensesEntities[1]);
    when(mockBox.put(any, any)).thenAnswer((_) async => Void());
    //act
    final result = await dataSource.modifyExpense(tExpensesList[0]);
    //assert
    expect(result, tExpensesList[0].id);

    verify(mockHiveOperations.openBox('expenses'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.get(tExpensesList[0].id));
    verify(mockBox.put(
        tProject.id,
        UserExpenseEntity(
          userId: john.id,
          projectId: tProject.id,
          amount: tAmount,
          currency: tCurrency.name,
          description: tDescription,
          receiversIds: [john.id, kate.id],
        )));
    verifyNoMoreInteractions(mockBox);
  });
}
