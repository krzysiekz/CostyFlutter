import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
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
  final currency = Currency(name: 'USD');

  final tExpense = UserExpense(
      id: 1,
      amount: Decimal.fromInt(10),
      currency: currency,
      description: 'First Expense',
      user: john,
      receivers: [john, kate]);

  test('should modify expense', () async {
    //arrange
    when(mockExpensesRepository.modifyExpense(tExpense))
        .thenAnswer((_) async => Right(tExpense.id));
    //act
    final result = await modifyExpense.call(Params(expense: tExpense));
    //assert
    expect(result, Right(tExpense.id));
    verify(mockExpensesRepository.modifyExpense(tExpense));
    verifyNoMoreInteractions(mockExpensesRepository);
  });
}
