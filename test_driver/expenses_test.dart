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

    await expectTextPresent("No expenses to display.", driver);
  });

  test('should display message when user tries to add expense with no users',
      () async {
    await driver.tap(find.byValueKey(Keys.PROJECT_DETAILS_ADD_EXPENSE_BUTTON));

    await expectTextPresent("Please add some users first.", driver);

    await driver.tap(find.byValueKey(Keys.ALERT_DIALOG_OK_BUTTON));
  });

  test('should add expense with default values', () async {
    await driver.tap(find.byValueKey(Keys.PROJECT_DETAILS_USERS_TAB));

    await createUser('John', driver);
    await createUser('Kate', driver);

    await driver.tap(find.byValueKey(Keys.PROJECT_DETAILS_EXPENSES_TAB));
    await driver.tap(find.byValueKey(Keys.PROJECT_DETAILS_ADD_EXPENSE_BUTTON));

    await expectKeyPresent(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY, driver);
    await driver.tap(find.byValueKey(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY));
    await driver.enterText("Test description");
    await driver.waitFor(find.text('Test description'));

    await expectKeyPresent(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY, driver);
    await driver.tap(find.byValueKey(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY));
    await driver.enterText("11");
    await driver.waitFor(find.text('11'));

    await expectKeyPresent(Keys.EXPENSE_FORM_USER_KEY, driver);
    await driver.tap(find.byValueKey(Keys.EXPENSE_FORM_USER_KEY));
    await driver.tap(find.text("John"));

    await expectKeyPresent(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY, driver);
    await driver.tap(find.byValueKey(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY));

    await expectTextPresent("Test description", driver);
    await expectTextPresent("John => John, Kate", driver);
    await expectTextPresent("11", driver);
  });

  test('should edit created expense', () async {
    await driver.tap(find.byValueKey("0_expense_edit"));

    await expectKeyPresent(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY, driver);
    await driver.tap(find.byValueKey(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY));
    await driver.enterText("Edited description");
    await driver.waitFor(find.text('Edited description'));

    await expectKeyPresent(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY, driver);
    await driver.tap(find.byValueKey(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY));
    await driver.enterText("12");
    await driver.waitFor(find.text('12'));

    await expectKeyPresent(Keys.EXPENSE_FORM_USER_KEY, driver);
    await driver.tap(find.byValueKey(Keys.EXPENSE_FORM_USER_KEY));
    await driver.tap(find.text("Kate"));

    await expectKeyPresent(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY, driver);
    await driver.tap(find.byValueKey(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY));

    await expectTextPresent("Edited description", driver);
    await expectTextPresent("Kate => John, Kate", driver);
    await expectTextPresent("12", driver);
  });

  test('should delete created expense', () async {
    await driver.scroll(
        find.byValueKey("expense_0"), -400, 0, Duration(milliseconds: 300));

    await expectKeyPresent(Keys.DELETE_CONFIRMATION_DELETE_BUTTON, driver);
    await driver.tap(find.byValueKey(Keys.DELETE_CONFIRMATION_DELETE_BUTTON));

    await expectTextPresent("No expenses to display.", driver);
  });
}
