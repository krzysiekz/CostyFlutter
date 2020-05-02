import 'package:bloc_test/bloc_test.dart';
import 'package:costy/app_localizations.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/keys.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/forms/new_expense_form_page.dart';
import 'package:costy/presentation/widgets/other/currency_dropdown_field.dart';
import 'package:costy/presentation/widgets/other/multi_select_chip.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCurrencyBloc extends MockBloc<CurrencyEvent, CurrencyState>
    implements CurrencyBloc {}

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

class MockReportBloc extends MockBloc<ReportEvent, ReportState>
    implements ReportBloc {}

class MockExpenseBloc extends MockBloc<ExpenseEvent, ExpenseState>
    implements ExpenseBloc {}

void main() {
  CurrencyBloc currencyBloc;
  UserBloc userBloc;
  ExpenseBloc expenseBloc;
  ReportBloc reportBloc;

  setUp(() {
    currencyBloc = MockCurrencyBloc();
    userBloc = MockUserBloc();
    expenseBloc = MockExpenseBloc();
    reportBloc = MockReportBloc();
  });

  tearDown(() {
    currencyBloc.close();
    userBloc.close();
    expenseBloc.close();
    reportBloc.close();
  });

  final Project tProject = Project(
    id: 1,
    name: "Test project",
    defaultCurrency: Currency(name: "PLN"),
    creationDateTime: DateTime.now(),
  );

  final List<Currency> tCurrencies = [
    Currency(name: "USD"),
    Currency(name: "PLN"),
    Currency(name: "EUR")
  ];

  final List<User> tUsers = [
    User(id: 1, name: "John"),
    User(id: 2, name: "Kate"),
  ];

  group('add new expense', () {
    var testedWidget;

    setUp(() {
      //arrange
      when(currencyBloc.state).thenAnswer(
        (_) => CurrencyLoaded(tCurrencies),
      );
      when(userBloc.state).thenAnswer(
        (_) => UserLoaded(tUsers),
      );

      testedWidget = MultiBlocProvider(
        providers: [
          BlocProvider<CurrencyBloc>.value(value: currencyBloc),
          BlocProvider<UserBloc>.value(value: userBloc),
          BlocProvider<ExpenseBloc>.value(value: expenseBloc),
          BlocProvider<ReportBloc>.value(value: reportBloc),
        ],
        child: MaterialApp(
          locale: Locale('en'),
          home: Scaffold(
            body: NewExpenseForm(project: tProject),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );
    });

    testWidgets('should display all available currencies and users properly',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        //arrange
        await tester.pumpWidget(testedWidget);
        await tester.pumpAndSettle();
        //assert
        final currencyDropdownFinder =
            find.byKey(Key(Keys.EXPENSE_FORM_CURRENCY_KEY));
        expect(currencyDropdownFinder, findsOneWidget);

        CurrencyDropdownField currencyDropdownField = (currencyDropdownFinder
            .evaluate()
            .first
            .widget as CurrencyDropdownField);

        expect(currencyDropdownField.currencies, tCurrencies);
        expect(find.text(tProject.defaultCurrency.name).hitTestable(),
            findsOneWidget);

        final receivers =
            find.byKey(Key(Keys.EXPENSE_FORM_RECEIVERS_FIELD_KEY));
        expect(receivers, findsOneWidget);
        MultiSelectChip receiversWidget =
            (receivers.evaluate().first.widget as MultiSelectChip);
        expect(receiversWidget.userList, tUsers);

        final receiverJohn = find.byKey(Key("receiver_John"));
        expect(receiverJohn, findsOneWidget);
        ChoiceChip receiverJohnChoiceChip =
            (receiverJohn.evaluate().first.widget as ChoiceChip);
        expect(receiverJohnChoiceChip.selected, true);

        final receiverKate = find.byKey(Key("receiver_Kate"));
        expect(receiverKate, findsOneWidget);
        ChoiceChip receiverKateChoiceChip =
            (receiverKate.evaluate().first.widget as ChoiceChip);
        expect(receiverKateChoiceChip.selected, true);
      });
    });

    testWidgets('should display proper validation errors when no data provided',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        //arrange
        await tester.pumpWidget(testedWidget);
        await tester.pumpAndSettle();
        //act
        final addExpenseButtonFinder =
            find.byKey(Key(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY));
        expect(addExpenseButtonFinder, findsOneWidget);
        await tester.tap(addExpenseButtonFinder);
        await tester.pumpAndSettle();
        //assert
        expect(find.text('Add expense'), findsNWidgets(2));
        expect(find.text('Description is required.'), findsOneWidget);
        expect(find.text('Field required.'), findsOneWidget);
        expect(find.text('Please select a user'), findsOneWidget);

        verify(currencyBloc.add(argThat(isA<GetCurrenciesEvent>())));
        verify(userBloc.add(argThat(isA<GetUsersEvent>())));

        verifyNever(expenseBloc.add(argThat(isA<AddExpenseEvent>())));
      });
    });

    testWidgets('should add expense with default currency and users',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        //arrange
        await tester.pumpWidget(testedWidget);
        await tester.pumpAndSettle();
        //act
        var descriptionFieldFinder =
            find.byKey(Key(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY));
        expect(descriptionFieldFinder, findsOneWidget);
        await tester.enterText(descriptionFieldFinder, "Some description");
        await tester.pumpAndSettle();

        var amountFieldFinder =
            find.byKey(Key(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY));
        expect(amountFieldFinder, findsOneWidget);
        await tester.enterText(amountFieldFinder, "10");
        await tester.pumpAndSettle();

        var userFinder = find.byKey(Key(Keys.EXPENSE_FORM_USER_KEY));
        expect(userFinder, findsOneWidget);
        await tester.tap(userFinder);
        await tester.pumpAndSettle();

        var userJohn = find.text("John").hitTestable();
        expect(userJohn, findsOneWidget);
        await tester.tap(userJohn);
        await tester.pumpAndSettle();

        await tester
            .tap(find.byKey(Key(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY)));
        await tester.pumpAndSettle();
        //assert
        expect(find.text('Description is required.'), findsNothing);
        expect(find.text('Amount is required'), findsNothing);
        expect(find.text('Please select a user'), findsNothing);

        verify(currencyBloc.add(argThat(isA<GetCurrenciesEvent>())));
        verify(userBloc.add(argThat(isA<GetUsersEvent>())));

        final AddExpenseEvent calledAddExpenseEvent =
            verify(expenseBloc.add(captureThat(isA<AddExpenseEvent>())))
                .captured
                .single;
        expect(calledAddExpenseEvent.currency, tProject.defaultCurrency);
        expect(calledAddExpenseEvent.project, tProject);
        expect(calledAddExpenseEvent.amount, Decimal.parse("10"));
        expect(calledAddExpenseEvent.description, "Some description");
        expect(calledAddExpenseEvent.receivers, tUsers);

        verify(expenseBloc.add(argThat(isA<GetExpensesEvent>())));
        verify(reportBloc.add(argThat(isA<GetReportEvent>())));
      });
    });
  });

  group('edit expense', () {
    var tExpense;
    var testedWidget;

    setUp(() {
      //arrange
      when(currencyBloc.state).thenAnswer(
        (_) => CurrencyLoaded(tCurrencies),
      );
      when(userBloc.state).thenAnswer(
        (_) => UserLoaded(tUsers),
      );

      tExpense = UserExpense(
          id: 1,
          receivers: [User(id: 1, name: "John")],
          user: User(id: 2, name: "Kate"),
          amount: Decimal.parse("10"),
          description: "Some description",
          currency: tCurrencies[0],
          dateTime: DateTime.now());

      testedWidget = MultiBlocProvider(
        providers: [
          BlocProvider<CurrencyBloc>.value(value: currencyBloc),
          BlocProvider<UserBloc>.value(value: userBloc),
          BlocProvider<ExpenseBloc>.value(value: expenseBloc),
          BlocProvider<ReportBloc>.value(value: reportBloc),
        ],
        child: MaterialApp(
          locale: Locale('en'),
          home: Scaffold(
            body: NewExpenseForm(project: tProject, expenseToEdit: tExpense),
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
        ),
      );
    });

    testWidgets('should prepopulate data properly during edit',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        //arrange
        await tester.pumpWidget(testedWidget);
        await tester.pumpAndSettle();
        //assert
        expect(find.text('Some description'), findsOneWidget);
        expect(find.byKey(Key('user_1')), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
        expect(find.text('USD').hitTestable(), findsOneWidget);
        expect(find.text('Modify expense'), findsNWidgets(2));

        final receiverJohn = find.byKey(Key("receiver_John"));
        expect(receiverJohn, findsOneWidget);
        ChoiceChip receiverJohnChoiceChip =
            (receiverJohn.evaluate().first.widget as ChoiceChip);
        expect(receiverJohnChoiceChip.selected, true);

        final receiverKate = find.byKey(Key("receiver_Kate"));
        expect(receiverKate, findsOneWidget);
        ChoiceChip receiverKateChoiceChip =
            (receiverKate.evaluate().first.widget as ChoiceChip);
        expect(receiverKateChoiceChip.selected, false);
      });
    });

    testWidgets('should edit expense', (WidgetTester tester) async {
      await tester.runAsync(() async {
        //arrange
        await tester.pumpWidget(testedWidget);
        await tester.pumpAndSettle();
        //act
        var descriptionFieldFinder =
            find.byKey(Key(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY));
        expect(descriptionFieldFinder, findsOneWidget);
        await tester.enterText(descriptionFieldFinder, "New description");
        await tester.pumpAndSettle();

        var amountFieldFinder =
            find.byKey(Key(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY));
        expect(amountFieldFinder, findsOneWidget);
        await tester.enterText(amountFieldFinder, "20");
        await tester.pumpAndSettle();

        var userFinder = find.byKey(Key(Keys.EXPENSE_FORM_USER_KEY));
        expect(userFinder, findsOneWidget);
        await tester.tap(userFinder);
        await tester.pumpAndSettle();

        var userKate = find.text("Kate").hitTestable();
        expect(userKate, findsOneWidget);
        await tester.tap(userKate);
        await tester.pumpAndSettle();

        var currencyDropDown = find.byKey(Key(Keys.EXPENSE_FORM_CURRENCY_KEY));
        expect(currencyDropDown, findsOneWidget);
        await tester.tap(currencyDropDown);
        await tester.pumpAndSettle();

        var plnCurrency = find.byKey(Key("currency_PLN")).hitTestable();
        expect(plnCurrency, findsOneWidget);
        await tester.tap(plnCurrency);
        await tester.pumpAndSettle();

        final receiverJohn = find.byKey(Key("receiver_John"));
        expect(receiverJohn, findsOneWidget);
        await tester.tap(receiverJohn);
        await tester.pumpAndSettle();

        final receiverKate = find.byKey(Key("receiver_Kate"));
        expect(receiverKate, findsOneWidget);
        await tester.tap(receiverKate);
        await tester.pumpAndSettle();

        await tester
            .tap(find.byKey(Key(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY)));
        await tester.pumpAndSettle();
        //assert
        expect(find.text('Description is required'), findsNothing);
        expect(find.text('Amount is required'), findsNothing);
        expect(find.text('Please select a user'), findsNothing);

        verify(currencyBloc.add(argThat(isA<GetCurrenciesEvent>())));
        verify(userBloc.add(argThat(isA<GetUsersEvent>())));

        final ModifyExpenseEvent calledAddExpenseEvent =
            verify(expenseBloc.add(captureThat(isA<ModifyExpenseEvent>())))
                .captured
                .single;
        expect(calledAddExpenseEvent.expense.id, tExpense.id);
        expect(calledAddExpenseEvent.expense.currency, tCurrencies[1]);
        expect(calledAddExpenseEvent.expense.amount, Decimal.parse("20"));
        expect(calledAddExpenseEvent.expense.description, "New description");
        expect(calledAddExpenseEvent.expense.receivers, [tUsers[1]]);

        verify(expenseBloc.add(argThat(isA<GetExpensesEvent>())));
        verify(reportBloc.add(argThat(isA<GetReportEvent>())));
      });
    });
  });
}
