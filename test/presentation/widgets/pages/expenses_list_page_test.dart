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

class MockExpenseBloc extends MockBloc<ExpenseState> implements ExpenseBloc {}

class MockUserBloc extends MockBloc<UserState> implements UserBloc {}

void main() {
  ExpenseBloc expenseBloc;
  UserBloc userBloc;
  Project tProject;
  UserExpense tExpense;

  Widget testedWidget;

  setUp(() {
    tProject = Project(
      id: 1,
      name: "Tested Project",
      defaultCurrency: const Currency(name: 'USD'),
      creationDateTime: DateTime.now(),
    );

    const User john = User(id: 3, name: "John");
    const User kate = User(id: 4, name: "Kate");

    tExpense = UserExpense(
        id: 2,
        amount: Decimal.fromInt(10),
        currency: const Currency(name: "USD"),
        description: 'First Expense',
        user: john,
        receivers: const [john, kate],
        dateTime: DateTime.now());

    expenseBloc = MockExpenseBloc();
    userBloc = MockUserBloc();

    //arrange
    when(expenseBloc.state).thenAnswer(
      (_) => ExpenseLoaded([tExpense]),
    );

    when(userBloc.state).thenAnswer(
      (_) => const UserLoaded([john, kate]),
    );

    testedWidget = MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => expenseBloc,
        ),
        BlocProvider(
          create: (_) => userBloc,
        )
      ],
      child: MaterialApp(
          locale: const Locale('en'),
          home: Scaffold(body: ExpensesListPage(project: tProject)),
          localizationsDelegates: const [
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

      final deleteButtonFinder = find.byKey(const Key('delete_expense_2'));
      final confirmDeleteButtonFinder =
          find.byKey(const Key(Keys.deleteConfirmationDeleteButton));
      //dismiss item
      expect(deleteButtonFinder, findsOneWidget);
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      //verify popup
      expect(find.text('Are you sure you wish to delete this item?'),
          findsOneWidget);
      expect(confirmDeleteButtonFinder, findsOneWidget);

      //click delete
      await tester.tap(confirmDeleteButtonFinder);
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

      final deleteButtonFinder = find.byKey(const Key('delete_expense_2'));
      final cancelButtonFinder =
          find.byKey(const Key(Keys.deleteConfirmationCancelButton));
      //dismiss item
      expect(deleteButtonFinder, findsOneWidget);
      await tester.tap(deleteButtonFinder);
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
