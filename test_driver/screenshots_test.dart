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
    ozzie = Ozzie.initWith(driver, groupName: 'screenshots');
    print('Waiting before running tests...');
    sleep(Duration(seconds: 1));
  });

  // Close the connection to the driver after the tests have completed.
  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
    ozzie.generateHtmlReport();
    print('Cleaned up...');
  });

  test('check flutter driver health', () async {
    final health = await driver.checkHealth();
    expect(health.status, HealthStatus.ok);
    print(health.status);
  });

  test('take screenshots', () async {
    await ozzie.takeScreenshot('1_no_projects');

    //create project
    await tapOnKey(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY, driver);
    await ozzie.takeScreenshot('2_add_projects');
    await expectKeyPresent(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY, driver);
    await tapOnKey(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY, driver);
    await driver.enterText("Weekend trip");
    await driver.waitFor(find.text('Weekend trip'));

    await expectKeyPresent(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY, driver);
    await tapOnKey(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY, driver);
    await tapOnText('USD', driver);

    await expectKeyPresent(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY, driver);
    await tapOnKey(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY, driver);

    await expectTextPresent('Weekend trip', driver);
    await expectTextPresent('USD', driver);

    //create second project
    await createProject('Shopping in Paris', 'EUR', driver);
    await ozzie.takeScreenshot('3_project_list');

    //remove second project
    await driver.scroll(
        find.byValueKey("project_1"), -400, 0, Duration(milliseconds: 300));

    await ozzie.takeScreenshot('4_delete_project');
    await expectKeyPresent(Keys.DELETE_CONFIRMATION_DELETE_BUTTON, driver);
    await tapOnKey(Keys.DELETE_CONFIRMATION_DELETE_BUTTON, driver);

    //go to project details
    await tapOnText('Weekend trip', driver);
    await tapOnKey(Keys.PROJECT_DETAILS_USERS_TAB, driver);
    await ozzie.takeScreenshot('5_project_details');

    //add user
    await tapOnKey(Keys.PROJECT_DETAILS_ADD_USER_BUTTON, driver);
    await ozzie.takeScreenshot('6_add_user');
    await expectKeyPresent(Keys.USER_FORM_NAME_FIELD_KEY, driver);
    await tapOnKey(Keys.USER_FORM_NAME_FIELD_KEY, driver);
    await driver.enterText('John');
    await driver.waitFor(find.text('John'));

    await expectKeyPresent(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY, driver);
    await tapOnKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY, driver);
    await expectTextPresent('John', driver);

    //add more users
    await createUser('Kate', driver);
    await createUser('Bob', driver);
    await createUser('Andrew', driver);
    await ozzie.takeScreenshot('7_user_list');

    //go to expenses tab
    await tapOnKey(Keys.PROJECT_DETAILS_EXPENSES_TAB, driver);

    //create expense
    await tapOnKey(Keys.PROJECT_DETAILS_ADD_EXPENSE_BUTTON, driver);
    await ozzie.takeScreenshot('8_new_expense');
    await expectKeyPresent(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY, driver);
    await tapOnKey(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY, driver);
    await driver.enterText('Dinner');
    await driver.waitFor(find.text('Dinner'));

    await expectKeyPresent(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY, driver);
    await tapOnKey(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY, driver);
    await driver.enterText('50.24');
    await driver.waitFor(find.text('50.24'));

    await expectKeyPresent(Keys.EXPENSE_FORM_USER_KEY, driver);
    await tapOnKey(Keys.EXPENSE_FORM_USER_KEY, driver);
    await tapOnText('John', driver);

    await expectKeyPresent(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY, driver);
    await tapOnKey(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY, driver);

    await expectTextPresent('Dinner', driver);
    await expectTextPresent("John => Andrew, Bob, John, Kate", driver);
    await expectTextPresent('50.24', driver);

    await createExpense(
        "Evening beer", "26", "Bob", "Bob => Andrew, Bob, John, Kate", driver);

    await ozzie.takeScreenshot('9_expense_list');

    //go to report tab
    await tapOnKey(Keys.PROJECT_DETAILS_REPORT_TAB, driver);
    await ozzie.takeScreenshot('10_report');
  }, timeout: Timeout(Duration(minutes: 5)));
}
