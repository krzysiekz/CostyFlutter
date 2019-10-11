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
  Currency eur;
  Currency pln;

  setUp(() {
    reportGenerator = ReportGeneratorImpl();
    john = User(id: 1, name: 'John');
    kate = User(id: 2, name: 'Kate');

    eur = Currency(name: 'EUR');
    pln = Currency(name: 'PLN');
  });

  UserExpense createExpense(
      User sender, List<User> receivers, Currency currency, int amount) {
    return UserExpense(
        id: 1,
        receivers: receivers,
        amount: Decimal.fromInt(amount),
        currency: currency,
        description: "Test",
        user: sender);
  }

  ReportEntry createReportEntry(
      User sender, User receiver, Currency currency, int amount) {
    return ReportEntry(
        receiver: receiver,
        amount: Decimal.fromInt(amount),
        currency: currency,
        sender: sender);
  }

  test('should return report with project project', () async {
    //arrange
    final project = Project(id: 1, name: "Test Project");
    final expectedReport = Report(project: project);
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report for single user should be empty', () async {
    //arrange
    final project = Project(id: 1, name: "Test Project");
    project.addExpense(createExpense(john, [john], eur, 10));

    final expectedReport = Report(project: project);
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report should be valid for two users and two currencies', () async {
    //arrange
    final project = Project(id: 1, name: "Test Project");
    project.addExpense(createExpense(john, [john, kate], eur, 50));
    project.addExpense(createExpense(kate, [john, kate], pln, 20));

    final expectedReport = Report(project: project);
    expectedReport.addEntry(createReportEntry(kate, john, eur, 25));
    expectedReport.addEntry(createReportEntry(john, kate, pln, 10));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report should be valid for two users', () async {
    //arrange
    final project = Project(id: 1, name: "Test Project");
    project.addExpense(createExpense(john, [john, kate], eur, 50));
    project.addExpense(createExpense(kate, [john, kate], eur, 20));

    final expectedReport = Report(project: project);
    expectedReport.addEntry(createReportEntry(kate, john, eur, 15));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });
}
