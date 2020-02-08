import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/report.dart';
import 'package:costy/data/models/report_entry.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/data/services/impl/report_generator_impl.dart';
import 'package:costy/data/services/report_generator.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ReportGenerator reportGenerator;
  User kate;
  User john;
  User bob;
  User adam;
  Currency eur;
  Currency pln;
  DateTime projectCreationDateTime;
  DateTime expenseDateTime;

  setUp(() {
    reportGenerator = ReportGeneratorImpl();
    john = User(id: 1, name: 'John');
    kate = User(id: 2, name: 'Kate');
    bob = User(id: 3, name: 'Bob');
    adam = User(id: 4, name: 'Adam');

    eur = Currency(name: 'EUR');
    pln = Currency(name: 'PLN');

    projectCreationDateTime = DateTime(2020, 1, 1, 10, 10, 10);
    expenseDateTime = DateTime.now();
  });

  UserExpense createExpense(
      User sender, List<User> receivers, Currency currency, int amount) {
    return UserExpense(
        id: 1,
        receivers: receivers,
        amount: Decimal.fromInt(amount),
        currency: currency,
        description: "Test",
        user: sender,
        dateTime: expenseDateTime);
  }

  ReportEntry createReportEntry(
      User sender, User receiver, Currency currency, double amount) {
    return ReportEntry(
      receiver: receiver,
      amount: Decimal.parse(amount.toString()),
      currency: currency,
      sender: sender,
    );
  }

  test('should return report with proper project', () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    final expectedReport = Report(project: project);
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report for single user should be empty', () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [john], eur, 10));

    final expectedReport = Report(project: project);
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report should be valid for two users and two currencies', () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [john, kate], eur, 50));
    project.addExpense(createExpense(kate, [john, kate], pln, 20));

    final expectedReport = Report(project: project);
    expectedReport.addEntry(createReportEntry(john, kate, pln, 10));
    expectedReport.addEntry(createReportEntry(kate, john, eur, 25));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report should be valid for two users', () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [john, kate], eur, 50));
    project.addExpense(createExpense(kate, [john, kate], eur, 20));

    final expectedReport = Report(project: project);
    expectedReport.addEntry(createReportEntry(kate, john, eur, 15));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report should be empty for 3 users when expenses are the same',
      () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [john, kate, bob], eur, 50));
    project.addExpense(createExpense(kate, [john, kate, bob], eur, 50));
    project.addExpense(createExpense(bob, [john, kate, bob], eur, 50));

    final expectedReport = Report(project: project);
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report should be empty for 2 users when expenses are the same',
      () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [john, kate], eur, 50));
    project.addExpense(createExpense(kate, [john, kate], eur, 50));

    final expectedReport = Report(project: project);
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report should be valid for multiple users', () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [john, kate, bob], eur, 9));
    project.addExpense(createExpense(kate, [john, kate, bob], eur, 18));
    project.addExpense(createExpense(bob, [john, kate, bob], eur, 27));

    final expectedReport = Report(project: project);
    expectedReport.addEntry(createReportEntry(john, kate, eur, 3));
    expectedReport.addEntry(createReportEntry(john, bob, eur, 6));
    expectedReport.addEntry(createReportEntry(kate, bob, eur, 3));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report should be valid when user is not paying for all other users',
      () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [john, kate], eur, 15));
    project.addExpense(createExpense(kate, [john, kate, bob], eur, 30));
    project.addExpense(createExpense(bob, [john, kate, bob], eur, 45));

    final expectedReport = Report(project: project);
    expectedReport.addEntry(createReportEntry(john, kate, eur, 2.5));
    expectedReport.addEntry(createReportEntry(john, bob, eur, 15));
    expectedReport.addEntry(createReportEntry(kate, bob, eur, 5));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report should be valid for multiple users and currencies', () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [john, kate, bob], eur, 9));
    project.addExpense(createExpense(kate, [john, kate, bob], eur, 18));
    project.addExpense(createExpense(bob, [john, kate, bob], eur, 27));
    project.addExpense(createExpense(john, [john, kate, bob], pln, 9));
    project.addExpense(createExpense(kate, [john, kate, bob], pln, 18));
    project.addExpense(createExpense(bob, [john, kate, bob], pln, 27));

    final expectedReport = Report(project: project);
    expectedReport.addEntry(createReportEntry(john, kate, eur, 3));
    expectedReport.addEntry(createReportEntry(john, bob, eur, 6));
    expectedReport.addEntry(createReportEntry(john, kate, pln, 3));
    expectedReport.addEntry(createReportEntry(john, bob, pln, 6));
    expectedReport.addEntry(createReportEntry(kate, bob, eur, 3));
    expectedReport.addEntry(createReportEntry(kate, bob, pln, 3));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('should not generate redundant entries when there are cycles', () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [kate], eur, 5));
    project.addExpense(createExpense(bob, [john], eur, 10));
    project.addExpense(createExpense(kate, [bob], eur, 15));

    final expectedReport = Report(project: project);
    expectedReport.addEntry(createReportEntry(bob, kate, eur, 10));
    expectedReport.addEntry(createReportEntry(john, bob, eur, 5));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('should not generate redundant entries when there are cycles 2',
      () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [kate], eur, 25));
    project.addExpense(createExpense(bob, [john], eur, 10));
    project.addExpense(createExpense(kate, [bob], eur, 15));

    final expectedReport = Report(project: project);
    expectedReport.addEntry(createReportEntry(bob, kate, eur, 5));
    expectedReport.addEntry(createReportEntry(kate, john, eur, 15));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('should not generate redundant entries when there are cycles 3',
      () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [kate], eur, 5));
    project.addExpense(createExpense(bob, [john], eur, 10));
    project.addExpense(createExpense(adam, [bob], eur, 15));
    project.addExpense(createExpense(kate, [adam], eur, 20));

    final expectedReport = Report(project: project);
    expectedReport.addEntry(createReportEntry(adam, kate, eur, 15));
    expectedReport.addEntry(createReportEntry(bob, adam, eur, 10));
    expectedReport.addEntry(createReportEntry(john, bob, eur, 5));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });
}
