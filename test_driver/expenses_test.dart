import 'dart:io';

import 'package:costy/keys.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  FlutterDriver driver;

  // Connect to the Flutter driver before running any tests.
  setUpAll(() async {
    driver = await FlutterDriver.connect();
    print('Waiting before running tests...');
    sleep(Duration(seconds: 1));
  });

  // Close the connection to the driver after the tests have completed.
  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  test('check flutter driver health', () async {
    final health = await driver.checkHealth();
    expect(health.status, HealthStatus.ok);
    print(health.status);
  });

  test('should display proper text when there is no expenses yet', () async {
    await createProject("Project1", "PLN", driver);

    await driver.tap(find.text('Project1'));

    var textToFind = 'No expenses to display.';
    await expectPresent(find.text(textToFind), driver, objectName: textToFind);
  });

  test('should display message when user tries to add expense with no users',
      () async {
    await driver.tap(find.byValueKey(Keys.PROJECT_DETAILS_ADD_EXPENSE_BUTTON));

    var textToFind = 'Please add some users first.';
    await expectPresent(find.text(textToFind), driver, objectName: textToFind);

    await driver.tap(find.byValueKey(Keys.ALERT_DIALOG_OK_BUTTON));
  });
}
