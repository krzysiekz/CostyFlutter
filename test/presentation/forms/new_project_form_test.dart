import 'package:bloc_test/bloc_test.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/keys.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/forms/new_project_form.dart';
import 'package:costy/presentation/widgets/other/currency_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCurrencyBloc extends MockBloc<CurrencyEvent, CurrencyState>
    implements CurrencyBloc {}

class MockProjectBloc extends MockBloc<ProjectEvent, ProjectState>
    implements ProjectBloc {}

void main() {
  group('add new project', () {
    CurrencyBloc currencyBloc;
    ProjectBloc projectBloc;

    setUp(() {
      currencyBloc = MockCurrencyBloc();
      projectBloc = MockProjectBloc();
    });

    tearDown(() {
      currencyBloc.close();
      projectBloc.close();
    });

    final List<Currency> tCurrencies = [
      Currency(name: "USD"),
      Currency(name: "PLN"),
      Currency(name: "EUR")
    ];

    testWidgets('should display all available currencies properly',
        (WidgetTester tester) async {
      //arrange
      when(currencyBloc.state).thenAnswer(
        (_) => CurrencyLoaded(tCurrencies),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CurrencyBloc>.value(value: currencyBloc),
            BlocProvider<ProjectBloc>.value(value: projectBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: NewProjectForm(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      //act
      final currencyDropdownFinder =
          find.byKey(Key(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY));
      expect(currencyDropdownFinder, findsOneWidget);
      //assert
      CurrencyDropdownField currencyDropdownField = (currencyDropdownFinder
          .evaluate()
          .first
          .widget as CurrencyDropdownField);

      expect(currencyDropdownField.currencies, tCurrencies);
    });

    testWidgets('should display proper validation errors',
        (WidgetTester tester) async {
      //arrange
      when(currencyBloc.state).thenAnswer(
        (_) => CurrencyLoaded(tCurrencies),
      );
      await tester.pumpWidget(
        BlocProvider<CurrencyBloc>(
          create: (_) => currencyBloc,
          child: MaterialApp(
            home: Scaffold(
              body: NewProjectForm(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      //act
      final addProjectButtonFinder =
          find.byKey(Key(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY));
      expect(addProjectButtonFinder, findsOneWidget);
      await tester.tap(addProjectButtonFinder);
      await tester.pumpAndSettle();
      //assert
      expect(find.text('Add Project'), findsOneWidget);
      expect(find.text('Project name is required'), findsOneWidget);
      expect(find.text('Please select a currency'), findsOneWidget);

      verify(currencyBloc.add(argThat(isA<GetCurrenciesEvent>())));

      verifyNever(projectBloc.add(argThat(isA<AddProjectEvent>())));
    });
  });

  group('edit project', () {});
}
