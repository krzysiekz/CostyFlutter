import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/data/repositories/expenses_repository.dart';
import 'package:costy/data/usecases/impl/get_expenses.dart';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  GetExpenses getExpenses;
  MockExpensesRepository mockExpensesRepository;

  setUp(() {
    mockExpensesRepository = MockExpensesRepository();
    getExpenses = GetExpenses(expensesRepository: mockExpensesRepository);
  });

  const currency = Currency(name: 'USD');
  const john = User(id: 1, name: 'John');
  const kate = User(id: 2, name: 'Kate');

  final tCreationDateTime = DateTime(2020, 1, 1, 10, 10, 10);
  final tProject = Project(
      id: 1,
      name: 'Test project',
      defaultCurrency: const Currency(name: 'USD'),
      creationDateTime: tCreationDateTime);
  final tDateTime = DateTime.now();
  final tExpensesList = [
    UserExpense(
        id: 1,
        amount: Decimal.fromInt(10),
        currency: currency,
        description: 'First Expense',
        user: john,
        receivers: const [john, kate],
        dateTime: tDateTime),
    UserExpense(
        id: 2,
        amount: Decimal.fromInt(20),
        currency: currency,
        description: 'Second Expense',
        user: kate,
        receivers: const [john, kate],
        dateTime: tDateTime),
  ];

  test('should get expenses for project', () async {
    //arrange
    when(mockExpensesRepository.getExpenses(any))
        .thenAnswer((_) async => Right(tExpensesList));
    //act
    final result = await getExpenses.call(GetExpensesParams(project: tProject));
    //assert
    expect(result, Right(tExpensesList));
    verify(mockExpensesRepository.getExpenses(tProject));
    verifyNoMoreInteractions(mockExpensesRepository);
  });
}
