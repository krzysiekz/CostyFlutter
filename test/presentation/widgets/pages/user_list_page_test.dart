import 'package:bloc_test/bloc_test.dart';
import 'package:costy/app_localizations.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/keys.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/pages/users_list_page.dart';
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
          home: Scaffold(body: UsersListPage(project: tProject)),
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

      final deleteButtonFinder = find.byKey(const Key('delete_user_1'));
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

      final deleteItemFinder = find.byKey(const Key('delete_user_1'));
      final confirmCancelButtonFinder =
          find.byKey(const Key(Keys.deleteConfirmationCancelButton));
      //dismiss item
      expect(deleteItemFinder, findsOneWidget);
      await tester.tap(deleteItemFinder);
      await tester.pumpAndSettle();

      //verify popup
      expect(find.text('Are you sure you wish to delete this item?'),
          findsOneWidget);
      expect(confirmCancelButtonFinder, findsOneWidget);

      //click delete
      await tester.tap(confirmCancelButtonFinder);
      await tester.pumpAndSettle();

      //assert
      verify(userBloc.add(argThat(isA<GetUsersEvent>())));
      verifyNever(userBloc.add(argThat(isA<DeleteUserEvent>())));
    });
  });
}
