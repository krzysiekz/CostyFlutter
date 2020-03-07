import 'package:bloc_test/bloc_test.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/keys.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/forms/new_user_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

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
    defaultCurrency: Currency(name: "PLN"),
    creationDateTime: DateTime.now(),
  );

  group('add new user', () {
    testWidgets('should display proper validation errors',
        (WidgetTester tester) async {
      //arrange
      await tester.pumpWidget(
        BlocProvider(
          create: (_) => userBloc,
          child: MaterialApp(
            home: Scaffold(
              body: NewUserForm(project: tProject),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      //act
      final addUserButtonFinder =
          find.byKey(Key(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY));
      expect(addUserButtonFinder, findsOneWidget);
      await tester.tap(addUserButtonFinder);
      await tester.pumpAndSettle();
      //assert
      expect(find.text('Add User'), findsOneWidget);
      expect(find.text("User's name is required"), findsOneWidget);

      verifyNever(userBloc.add(argThat(isA<AddUserEvent>())));
    });

    testWidgets('should add user', (WidgetTester tester) async {
      //arrange
      await tester.pumpWidget(
        BlocProvider(
          create: (_) => userBloc,
          child: MaterialApp(
            home: Scaffold(
              body: NewUserForm(project: tProject),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      //act
      var nameFieldFinder = find.byKey(Key(Keys.USER_FORM_NAME_FIELD_KEY));
      expect(nameFieldFinder, findsOneWidget);
      await tester.enterText(nameFieldFinder, "John");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY)));
      await tester.pumpAndSettle();
      //assert
      expect(find.text("User's name is required"), findsNothing);

      verify(userBloc.add(AddUserEvent("John", tProject)));
      verify(userBloc.add(argThat(isA<GetUsersEvent>())));
    });
  });

  group('modify user', () {
    final User userToModify = User(id: 1, name: "John");

    testWidgets('should prepopulate data properly during edit',
        (WidgetTester tester) async {
      //arrange
      await tester.pumpWidget(
        BlocProvider(
          create: (_) => userBloc,
          child: MaterialApp(
            home: Scaffold(
              body: NewUserForm(project: tProject, userToModify: userToModify),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      //assert
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Edit User'), findsOneWidget);
    });

    testWidgets('should edit user', (WidgetTester tester) async {
      //arrange
      await tester.pumpWidget(
        BlocProvider(
          create: (_) => userBloc,
          child: MaterialApp(
            home: Scaffold(
              body: NewUserForm(project: tProject, userToModify: userToModify),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      //act
      var nameFieldFinder = find.byKey(Key(Keys.USER_FORM_NAME_FIELD_KEY));
      expect(nameFieldFinder, findsOneWidget);
      await tester.enterText(nameFieldFinder, "Kate");
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY)));
      await tester.pumpAndSettle();
      //assert
      expect(find.text("Userk's name is required"), findsNothing);

      verify(userBloc
          .add(ModifyUserEvent(User(id: userToModify.id, name: "Kate"))));
      verify(userBloc.add(argThat(isA<GetUsersEvent>())));
    });
  });
}
