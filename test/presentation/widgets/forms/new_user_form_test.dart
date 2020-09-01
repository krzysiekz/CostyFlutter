import 'package:bloc_test/bloc_test.dart';
import 'package:costy/app_localizations.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/keys.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/forms/new_user_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserBloc extends MockBloc<UserState> implements UserBloc {}

void main() {
  UserBloc userBloc;

  setUp(() {
    userBloc = MockUserBloc();
  });

  tearDown(() {
    userBloc.close();
  });

  final Project tProject = Project(
    id: 1,
    name: "Test project",
    defaultCurrency: const Currency(name: "PLN"),
    creationDateTime: DateTime.now(),
  );

  group('add new user', () {
    Widget testedWidget;

    setUp(() {
      testedWidget = BlocProvider(
        create: (_) => userBloc,
        child: MaterialApp(
            locale: const Locale('en'),
            home: Scaffold(
              body: NewPersonForm(project: tProject),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
            ]),
      );
    });

    testWidgets('should display proper validation errors',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        //arrange
        await tester.pumpWidget(testedWidget);
        await tester.pumpAndSettle();
        //act
        final addUserButtonFinder =
            find.byKey(const Key(Keys.userFormAddEditButtonKey));
        expect(addUserButtonFinder, findsOneWidget);
        await tester.tap(addUserButtonFinder);
        await tester.pumpAndSettle();
        //assert
        expect(find.text('Add user'), findsNWidgets(2));
        expect(find.text("User's name is required"), findsOneWidget);

        verifyNever(userBloc.add(argThat(isA<AddUserEvent>())));
      });
    });

    testWidgets('should add user', (WidgetTester tester) async {
      await tester.runAsync(() async {
        //arrange
        await tester.pumpWidget(testedWidget);
        await tester.pumpAndSettle();
        //act
        final nameFieldFinder =
            find.byKey(const Key(Keys.userFormNameFieldKey));
        expect(nameFieldFinder, findsOneWidget);
        await tester.enterText(nameFieldFinder, "John");
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key(Keys.userFormAddEditButtonKey)));
        await tester.pumpAndSettle();
        //assert
        expect(find.text("User's name is required"), findsNothing);

        verify(userBloc.add(AddUserEvent("John", tProject)));
        verify(userBloc.add(argThat(isA<GetUsersEvent>())));
      });
    });
  });

  group('modify user', () {
    User userToModify;
    Widget testedWidget;

    setUp(() {
      userToModify = const User(id: 1, name: "John");

      testedWidget = BlocProvider(
        create: (_) => userBloc,
        child: MaterialApp(
            locale: const Locale('en'),
            home: Scaffold(
              body: NewPersonForm(project: tProject, userToModify: userToModify),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
            ]),
      );
    });

    testWidgets('should prepopulate data properly during edit',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        //arrange
        await tester.pumpWidget(testedWidget);
        await tester.pumpAndSettle();
        //assert
        expect(find.text('John'), findsOneWidget);
        expect(find.text('Modify user'), findsNWidgets(2));
      });
    });

    testWidgets('should edit user', (WidgetTester tester) async {
      await tester.runAsync(() async {
        //arrange
        await tester.pumpWidget(testedWidget);
        await tester.pumpAndSettle();
        //act
        final nameFieldFinder =
            find.byKey(const Key(Keys.userFormNameFieldKey));
        expect(nameFieldFinder, findsOneWidget);
        await tester.enterText(nameFieldFinder, "Kate");
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key(Keys.userFormAddEditButtonKey)));
        await tester.pumpAndSettle();
        //assert
        expect(find.text("Userk's name is required"), findsNothing);

        verify(userBloc
            .add(ModifyUserEvent(User(id: userToModify.id, name: "Kate"))));
        verify(userBloc.add(argThat(isA<GetUsersEvent>())));
      });
    });
  });
}
