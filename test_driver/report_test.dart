import 'dart:io';

import 'package:costy/keys.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:ozzie/ozzie.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  FlutterDriver driver;
  Ozzie ozzie;

  // Connect to the Flutter driver before running any tests.
  setUpAll(() async {
    driver = await FlutterDriver.connect();
    ozzie = Ozzie.initWith(driver, groupName: 'report');
    sleep(const Duration(seconds: 1));
  });

  // Close the connection to the driver after the tests have completed.
  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
    ozzie.generateHtmlReport();
  });

  test('check flutter driver health', () async {
    final health = await driver.checkHealth();
    expect(health.status, HealthStatus.ok);
  });

  testWithScreenshots('should display report properly', () => ozzie, () async {
    await createProject("Project1", "PLN", driver);

    await tapOnText('Project1', driver);
    await tapOnKey(Keys.projectDetailsUsersTab, driver);

    await createUser('John', driver);
    await createUser('Kate', driver);

    await tapOnKey(Keys.projectDetailsExpensesTab, driver);

    await createExpense(
        "Some expense", "20", "John", "John => John, Kate", driver);

    await tapOnKey(Keys.projectDetailsReportTab, driver);

    await expectTextPresent("From: Kate", driver);
    await expectTextPresent("To: John", driver);
    await expectTextPresent("10.00", driver);
    await expectTextPresent("PLN", driver);
  });
}
