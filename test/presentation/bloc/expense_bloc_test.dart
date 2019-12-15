import 'package:bloc_test/bloc_test.dart';
import 'package:costy/data/errors/failures.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/data/usecases/impl/add_expense.dart';
import 'package:costy/data/usecases/impl/delete_expense.dart';
import 'package:costy/data/usecases/impl/get_expenses.dart';
import 'package:costy/data/usecases/impl/modify_expense.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetExpenses extends Mock implements GetExpenses {}

class MockAddExpense extends Mock implements AddExpense {}

class MockDeleteExpense extends Mock implements DeleteExpense {}

class MockModifyExpense extends Mock implements ModifyExpense {}

void main() {
  MockGetExpenses mockGetExpenses;
  MockAddExpense mockAddExpense;
  MockDeleteExpense mockDeleteExpense;
  MockModifyExpense mockModifyExpense;

  setUp(() {
    mockGetExpenses = MockGetExpenses();
    mockAddExpense = MockAddExpense();
    mockDeleteExpense = MockDeleteExpense();
    mockModifyExpense = MockModifyExpense();
  });

  final currency = Currency(name: 'USD');
  final john = User(id: 1, name: 'John');
  final kate = User(id: 2, name: 'Kate');

  final tProject = Project(
      id: 1, name: 'Test project', defaultCurrency: Currency(name: 'USD'));
  final tExpensesList = [
    UserExpense(
        id: 1,
        amount: Decimal.fromInt(10),
        currency: currency,
        description: 'First Expense',
        user: john,
        receivers: [john, kate]),
    UserExpense(
        id: 2,
        amount: Decimal.fromInt(20),
        currency: currency,
        description: 'Second Expense',
        user: kate,
        receivers: [john, kate]),
  ];

  blocTest('should emit empty state initially', build: () {
    return ExpenseBloc(
        getExpenses: mockGetExpenses,
        addExpense: mockAddExpense,
        modifyExpense: mockModifyExpense,
        deleteExpense: mockDeleteExpense);
  }, expect: [ExpenseEmpty()]);

  blocTest('should emit proper states when getting expenses',
      build: () {
        when(mockGetExpenses.call(any))
            .thenAnswer((_) async => Right(tExpensesList));
        return ExpenseBloc(
            getExpenses: mockGetExpenses,
            addExpense: mockAddExpense,
            modifyExpense: mockModifyExpense,
            deleteExpense: mockDeleteExpense);
      },
      act: (bloc) => bloc.add(GetExpensesEvent(tProject)),
      expect: [ExpenseEmpty(), ExpenseLoading(), ExpenseLoaded(tExpensesList)]);

  blocTest('should emit proper states in case of error when getting expenses',
      build: () {
        when(mockGetExpenses.call(any))
            .thenAnswer((_) async => Left(DataSourceFailure()));
        return ExpenseBloc(
            getExpenses: mockGetExpenses,
            addExpense: mockAddExpense,
            modifyExpense: mockModifyExpense,
            deleteExpense: mockDeleteExpense);
      },
      act: (bloc) => bloc.add(GetExpensesEvent(tProject)),
      expect: [
        ExpenseEmpty(),
        ExpenseLoading(),
        ExpenseError(DATASOURCE_FAILURE_MESSAGE)
      ]);

  blocTest('should emit proper states when adding expense',
      build: () {
        when(mockAddExpense.call(any))
            .thenAnswer((_) async => Right(tExpensesList[0].id));
        return ExpenseBloc(
            getExpenses: mockGetExpenses,
            addExpense: mockAddExpense,
            modifyExpense: mockModifyExpense,
            deleteExpense: mockDeleteExpense);
      },
      act: (bloc) => bloc.add(AddExpenseEvent(
          user: tExpensesList[0].user,
          amount: tExpensesList[0].amount,
          currency: tExpensesList[0].currency,
          description: tExpensesList[0].description,
          project: tProject,
          receivers: tExpensesList[0].receivers)),
      expect: [
        ExpenseEmpty(),
        ExpenseLoading(),
        ExpenseAdded(tExpensesList[0].id)
      ]);

  blocTest('should emit proper states in case of error when adding expense',
      build: () {
        when(mockAddExpense.call(any))
            .thenAnswer((_) async => Left(DataSourceFailure()));
        return ExpenseBloc(
            getExpenses: mockGetExpenses,
            addExpense: mockAddExpense,
            modifyExpense: mockModifyExpense,
            deleteExpense: mockDeleteExpense);
      },
      act: (bloc) => bloc.add(AddExpenseEvent(
          user: tExpensesList[0].user,
          amount: tExpensesList[0].amount,
          currency: tExpensesList[0].currency,
          description: tExpensesList[0].description,
          project: tProject,
          receivers: tExpensesList[0].receivers)),
      expect: [
        ExpenseEmpty(),
        ExpenseLoading(),
        ExpenseError(DATASOURCE_FAILURE_MESSAGE)
      ]);

  blocTest('should emit proper states when deleting expense',
      build: () {
        when(mockDeleteExpense.call(any))
            .thenAnswer((_) async => Right(tExpensesList[0].id));
        return ExpenseBloc(
            getExpenses: mockGetExpenses,
            addExpense: mockAddExpense,
            modifyExpense: mockModifyExpense,
            deleteExpense: mockDeleteExpense);
      },
      act: (bloc) => bloc.add(DeleteExpenseEvent(tExpensesList[0].id)),
      expect: [
        ExpenseEmpty(),
        ExpenseLoading(),
        ExpenseDeleted(tExpensesList[0].id)
      ]);

  blocTest('should emit proper states in case of error when deleting expense',
      build: () {
        when(mockDeleteExpense.call(any))
            .thenAnswer((_) async => Left(DataSourceFailure()));
        return ExpenseBloc(
            getExpenses: mockGetExpenses,
            addExpense: mockAddExpense,
            modifyExpense: mockModifyExpense,
            deleteExpense: mockDeleteExpense);
      },
      act: (bloc) => bloc.add(DeleteExpenseEvent(tExpensesList[0].id)),
      expect: [
        ExpenseEmpty(),
        ExpenseLoading(),
        ExpenseError(DATASOURCE_FAILURE_MESSAGE)
      ]);

  blocTest('should emit proper states when modifying expense',
      build: () {
        when(mockModifyExpense.call(any))
            .thenAnswer((_) async => Right(tExpensesList[0].id));
        return ExpenseBloc(
            getExpenses: mockGetExpenses,
            addExpense: mockAddExpense,
            modifyExpense: mockModifyExpense,
            deleteExpense: mockDeleteExpense);
      },
      act: (bloc) => bloc.add(ModifyExpenseEvent(tExpensesList[0])),
      expect: [
        ExpenseEmpty(),
        ExpenseLoading(),
        ExpenseModified(tExpensesList[0].id)
      ]);

  blocTest('should emit proper states in case of error when modifying expense',
      build: () {
        when(mockModifyExpense.call(any))
            .thenAnswer((_) async => Left(DataSourceFailure()));
        return ExpenseBloc(
            getExpenses: mockGetExpenses,
            addExpense: mockAddExpense,
            modifyExpense: mockModifyExpense,
            deleteExpense: mockDeleteExpense);
      },
      act: (bloc) => bloc.add(ModifyExpenseEvent(tExpensesList[0])),
      expect: [
        ExpenseEmpty(),
        ExpenseLoading(),
        ExpenseError(DATASOURCE_FAILURE_MESSAGE)
      ]);
}
