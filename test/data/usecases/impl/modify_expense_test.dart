import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/repositories/expenses_repository.dart';
import 'package:costy/data/usecases/impl/modify_expense.dart';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  ModifyExpense modifyExpense;
  MockExpensesRepository mockExpensesRepository;

  setUp(() {
    mockExpensesRepository = MockExpensesRepository();
    modifyExpense = ModifyExpense(expensesRepository: mockExpensesRepository);
  });

  final john = User(id: 1, name: 'John');
  final kate = User(id: 2, name: 'Kate');

  final tAmount = Decimal.fromInt(10);
  final tCurrency = Currency(name: 'USD');
  final tDescription = 'First Expense';
  final tReceivers = [john, kate];
  final tExpenseId = 1;

  test('should modify expense', () async {
    //arrange
    when(mockExpensesRepository.modifyExpense(
            expenseId: anyNamed('expenseId'),
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            description: anyNamed('description'),
            user: anyNamed('user'),
            receivers: anyNamed('receivers')))
        .thenAnswer((_) async => Right(tExpenseId));
    //act
    final result = await modifyExpense.call(Params(
        expenseId: tExpenseId,
        amount: tAmount,
        currency: tCurrency,
        description: tDescription,
        user: john,
        receivers: tReceivers));
    //assert
    expect(result, Right(tExpenseId));
    verify(mockExpensesRepository.modifyExpense(
        expenseId: tExpenseId,
        amount: tAmount,
        currency: tCurrency,
        description: tDescription,
        user: john,
        receivers: tReceivers));
    verifyNoMoreInteractions(mockExpensesRepository);
  });
}
