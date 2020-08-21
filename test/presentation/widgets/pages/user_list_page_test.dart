import 'package:bloc_test/bloc_test.dart';
import 'package:costy/app_localizations.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/keys.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/pages/user_list_page.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserBloc extends MockBloc<UserState> implements UserBloc {}

class MockExpenseBloc extends MockBloc<ExpenseState> implements ExpenseBloc {}

void main() {
  UserBloc userBloc;
  ExpenseBloc expenseBloc;

  Project tProject;
  User tUser;

  Widget testedWidget;

  setUp(() {
    tProject = Project(
      id: 1,
      name: "Tested Project",
      defaultCurrency: const Currency(name: 'USD'),
      creationDateTime: DateTime.now(),
    );

    tUser = const User(id: 1, name: "John");

    userBloc = MockUserBloc();
    expenseBloc = MockExpenseBloc();

    //arrange
    when(userBloc.state).thenAnswer(
      (_) => UserLoaded([tUser]),
    );

    when(expenseBloc.state).thenAnswer(
      (_) => const ExpenseLoaded([]),
    );

    testedWidget = MultiBlocProvider(
      providers: [
        BlocProvider<ExpenseBloc>.value(value: expenseBloc),
        BlocProvider<UserBloc>.value(value: userBloc),
      ],
      child: MaterialApp(
          locale: const Locale('en'),
          home: UserListPage(project: tProject),
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ]),
    );
  });

  tearDown(() {
    userBloc.close();
    expenseBloc.close();
  });

  testWidgets('should delete item if confirmed', (WidgetTester tester) async {
    await tester.runAsync(() async {
      //arrange
      await tester.pumpWidget(testedWidget);
      await tester.pumpAndSettle();

      final itemFinder = find.byType(Dismissible);
      final deleteButtonFinder =
          find.byKey(const Key(Keys.deleteConfirmationDeleteButton));
      //dismiss item
      expect(itemFinder, findsOneWidget);
      await tester.drag(itemFinder, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      //verify popup
      expect(find.text('Are you sure you wish to delete this item?'),
          findsOneWidget);
      expect(deleteButtonFinder, findsOneWidget);

      //click delete
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      //assert
      verify(userBloc.add(argThat(isA<GetUsersEvent>())));
      verify(userBloc.add(DeleteUserEvent(tUser.id)));
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
          find.byKey(const Key(Keys.deleteConfirmationCancelButton));
      //dismiss item
      expect(itemFinder, findsOneWidget);
      await tester.drag(itemFinder, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      //verify popup
      expect(find.text('Are you sure you wish to delete this item?'),
          findsOneWidget);
      expect(cancelButtonFinder, findsOneWidget);

      //click delete
      await tester.tap(cancelButtonFinder);
      await tester.pumpAndSettle();

      //assert
      verify(userBloc.add(argThat(isA<GetUsersEvent>())));
      verifyNever(userBloc.add(argThat(isA<DeleteUserEvent>())));
    });
  });

  testWidgets('should not delete item if user used in expense',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      //arrange
      final tExpense = UserExpense(
          id: 1,
          amount: Decimal.fromInt(10),
          currency: const Currency(name: "USD"),
          description: 'First Expense',
          user: tUser,
          receivers: [tUser],
          dateTime: DateTime.now());

      when(expenseBloc.state).thenAnswer(
        (_) => ExpenseLoaded([tExpense]),
      );

      await tester.pumpWidget(testedWidget);
      await tester.pumpAndSettle();

      final itemFinder = find.byType(Dismissible);
      //dismiss item
      expect(itemFinder, findsOneWidget);
      await tester.drag(itemFinder, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      //verify popup
      expect(
          find.text(
              'Cannot remove user that is used in expense. Please remove expense first.'),
          findsOneWidget);

      //assert
      verify(userBloc.add(argThat(isA<GetUsersEvent>())));
      verifyNever(userBloc.add(argThat(isA<DeleteUserEvent>())));
    });
  });
}
