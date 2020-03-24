import 'package:bloc_test/bloc_test.dart';
import 'package:costy/app_localizations.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/keys.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/pages/expenses_list_page.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockExpenseBloc extends MockBloc<ExpenseEvent, ExpenseState>
    implements ExpenseBloc {}

void main() {
  ExpenseBloc expenseBloc;
  Project tProject;
  UserExpense tExpense;

  var testedWidget;

  setUp(() {
    tProject = Project(
      id: 1,
      name: "Tested Project",
      defaultCurrency: Currency(name: 'USD'),
      creationDateTime: DateTime.now(),
    );

    tExpense = UserExpense(
        id: 2,
        amount: Decimal.fromInt(10),
        currency: Currency(name: "USD"),
        description: 'First Expense',
        user: User(id: 3, name: "John"),
        receivers: [User(id: 3, name: "John"), User(id: 4, name: "Kate")],
        dateTime: DateTime.now());

    expenseBloc = MockExpenseBloc();

    //arrange
    when(expenseBloc.state).thenAnswer(
      (_) => ExpenseLoaded([tExpense]),
    );

    testedWidget = BlocProvider(
      create: (_) => expenseBloc,
      child: MaterialApp(
          locale: Locale('en'),
          home: ExpensesListPage(project: tProject),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ]),
    );
  });

  tearDown(() {
    expenseBloc.close();
  });

  testWidgets('should delete item if confirmed', (WidgetTester tester) async {
    await tester.runAsync(() async {
      //arrange
      await tester.pumpWidget(testedWidget);
      await tester.pumpAndSettle();

      final itemFinder = find.byType(Dismissible);
      final deleteButtonFinder =
          find.byKey(Key(Keys.DELETE_CONFIRMATION_DELETE_BUTTON));
      //dismiss item
      expect(itemFinder, findsOneWidget);
      await tester.drag(itemFinder, Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      //verify popup
      expect(find.text('Are you sure you wish to delete this item?'),
          findsOneWidget);
      expect(deleteButtonFinder, findsOneWidget);

      //click delete
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      //assert
      verify(expenseBloc.add(argThat(isA<GetExpensesEvent>())));
      verify(expenseBloc.add(DeleteExpenseEvent(tExpense.id)));
    });
  });

  testWidgets('should not delete item if not confirmed',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      //arrange
      await tester.pumpWidget(testedWidget);
      await tester.pumpAndSettle();

      final itemFinder = find.byType(Dismissible);
      final cancelButtonFinder =
          find.byKey(Key(Keys.DELETE_CONFIRMATION_CANCEL_BUTTON));
      //dismiss item
      expect(itemFinder, findsOneWidget);
      await tester.drag(itemFinder, Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      //verify popup
      expect(find.text('Are you sure you wish to delete this item?'),
          findsOneWidget);
      expect(cancelButtonFinder, findsOneWidget);

      //click delete
      await tester.tap(cancelButtonFinder);
      await tester.pumpAndSettle();

      //assert
      verify(expenseBloc.add(argThat(isA<GetExpensesEvent>())));
      verifyNever(expenseBloc.add(argThat(isA<DeleteExpenseEvent>())));
    });
  });
}
