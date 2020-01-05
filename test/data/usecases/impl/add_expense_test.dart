import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/repositories/expenses_repository.dart';
import 'package:costy/data/usecases/impl/add_expense.dart';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  AddExpense addExpense;
  MockExpensesRepository mockExpensesRepository;

  setUp(() {
    mockExpensesRepository = MockExpensesRepository();
    addExpense = AddExpense(expensesRepository: mockExpensesRepository);
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

  test('should add expense to project', () async {
    //arrange
    when(mockExpensesRepository.addExpense(
            project: anyNamed('project'),
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            description: anyNamed('description'),
            user: anyNamed('user'),
            receivers: anyNamed('receivers')))
        .thenAnswer((_) async => Right(tExpenseId));
    //act
    final result = await addExpense.call(AddExpenseParams(
        project: tProject,
        amount: tAmount,
        currency: tCurrency,
        description: tDescription,
        user: john,
        receivers: tReceivers));
    //assert
    expect(result, Right(tExpenseId));
    verify(mockExpensesRepository.addExpense(
        project: tProject,
        amount: tAmount,
        currency: tCurrency,
        description: tDescription,
        user: john,
        receivers: tReceivers));
    verifyNoMoreInteractions(mockExpensesRepository);
  });
}
