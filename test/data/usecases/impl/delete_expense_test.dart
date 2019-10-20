import 'package:costy/data/repositories/expenses_repository.dart';
import 'package:costy/data/usecases/impl/delete_expense.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  DeleteExpense deleteExpense;
  MockExpensesRepository mockExpensesRepository;

  setUp(() {
    mockExpensesRepository = MockExpensesRepository();
    deleteExpense = DeleteExpense(expensesRepository: mockExpensesRepository);
  });

  final tExpenseId = 1;

  test('should delete expense', () async {
    //arrange
    when(mockExpensesRepository.deleteExpense(any))
        .thenAnswer((_) async => Right(tExpenseId));
    //act
    final result = await deleteExpense.call(Params(expenseId: tExpenseId));
    //assert
    expect(result, Right(tExpenseId));
    verify(mockExpensesRepository.deleteExpense(tExpenseId));
    verifyNoMoreInteractions(mockExpensesRepository);
  });
}
