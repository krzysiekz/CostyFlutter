import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/report.dart';
import 'package:costy/data/models/report_entry.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/data/services/impl/report_formatter_impl.dart';
import 'package:costy/data/services/report_formatter.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ReportFormatter reportFormatter;
  User kate;
  User john;
  Currency eur;
  Currency pln;
  DateTime projectCreationDateTime;
  DateTime expenseDateTime;

  setUp(() {
    reportFormatter = ReportFormatterImpl();
    john = User(id: 1, name: 'John');
    kate = User(id: 2, name: 'Kate');

    eur = Currency(name: 'EUR');
    pln = Currency(name: 'PLN');

    projectCreationDateTime = DateTime(2020, 1, 1, 10, 10, 10);
    expenseDateTime = DateTime(2020, 1, 1, 10, 10, 10);
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

  test('should return properly formatted report', () async {
    //arrange
    final project = Project(
        id: 1,
        name: "Test Project",
        defaultCurrency: eur,
        creationDateTime: projectCreationDateTime);
    project.addExpense(createExpense(john, [john, kate], eur, 50));
    project.addExpense(createExpense(kate, [john, kate], pln, 20));

    final report = Report(project: project);
    report.addEntry(createReportEntry(john, kate, pln, 10));
    report.addEntry(createReportEntry(kate, john, eur, 25));

    final expectedText = """
Test Project

01/01/2020 10:10, 50.00 EUR, Test, John -> John, Kate
01/01/2020 10:10, 20.00 PLN, Test, Kate -> John, Kate

John -> Kate: 10.00 PLN
Kate -> John: 25.00 EUR
""";
    //act
    final result = await reportFormatter.format(report);
    //assert
    expect(result, expectedText);
  });
}
