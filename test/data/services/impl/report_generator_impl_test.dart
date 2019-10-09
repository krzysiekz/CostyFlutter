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

  setUp(() {
    reportGenerator = ReportGeneratorImpl();
  });

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
    final john = User(id: 1, name: 'John');
    final project = Project(id: 1, name: "Test Project");

    project.addExpense(
      UserExpense(
          id: 1,
          receivers: [john],
          amount: Decimal.fromInt(10),
          currency: Currency(name: 'USD'),
          description: "Test",
          user: john),
    );
    final expectedReport = Report(project: project);
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });

  test('report should be valid for two users and two currencies', () async {
    //arrange
    final john = User(id: 1, name: 'John');
    final kate = User(id: 2, name: 'Kate');
    final project = Project(id: 1, name: "Test Project");

    project.addExpense(
      UserExpense(
          id: 1,
          receivers: [john, kate],
          amount: Decimal.fromInt(50),
          currency: Currency(name: 'EUR'),
          description: "Test",
          user: john),
    );

    project.addExpense(
      UserExpense(
          id: 2,
          receivers: [john, kate],
          amount: Decimal.fromInt(20),
          currency: Currency(name: 'PLN'),
          description: "Test",
          user: kate),
    );
    final expectedReport = Report(project: project);
    expectedReport.addEntry(ReportEntry(
        amount: Decimal.fromInt(25),
        currency: Currency(name: 'EUR'),
        receiver: john,
        sender: kate));
    expectedReport.addEntry(ReportEntry(
        amount: Decimal.fromInt(10),
        currency: Currency(name: 'PLN'),
        receiver: kate,
        sender: john));
    //act
    final result = await reportGenerator.generate(project);
    //assert
    expect(result, expectedReport);
  });
}
