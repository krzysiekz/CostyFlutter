import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/data/repositories/expenses_repository.dart';
import 'package:costy/data/usecases/impl/get_expenses_for_project.dart';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  GetExpensesForProject getExpensesForProject;
  MockExpensesRepository mockExpensesRepository;

  setUp(() {
    mockExpensesRepository = MockExpensesRepository();
    getExpensesForProject =
        GetExpensesForProject(expensesRepository: mockExpensesRepository);
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

  test('should get expenses for project', () async {
    //arrange
    when(mockExpensesRepository.getExpenses(any))
        .thenAnswer((_) async => Right(tExpensesList));
    //act
    final result = await getExpensesForProject.call(Params(project: tProject));
    //assert
    expect(result, Right(tExpensesList));
    verify(mockExpensesRepository.getExpenses(tProject));
    verifyNoMoreInteractions(mockExpensesRepository);
  });
}
