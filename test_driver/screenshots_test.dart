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

  test('take screenshots', () async {
    await ozzie.takeScreenshot('1_no_projects');

    //create project
    await tapOnKey(Keys.projectlistAddProjectButtonKey, driver);
    await ozzie.takeScreenshot('2_add_projects');
    await expectKeyPresent(Keys.projectFormProjectNameFieldKey, driver);
    await tapOnKey(Keys.projectFormProjectNameFieldKey, driver);
    await driver.enterText("Weekend trip");
    await driver.waitFor(find.text('Weekend trip'));

    await expectKeyPresent(Keys.projectFormDefaultCurrencyKey, driver);
    await tapOnKey(Keys.projectFormDefaultCurrencyKey, driver);
    await tapOnText('USD', driver);

    await expectKeyPresent(Keys.projectFormAddEditButtonKey, driver);
    await tapOnKey(Keys.projectFormAddEditButtonKey, driver);

    await expectTextPresent('Weekend trip', driver);
    await expectTextPresent('USD', driver);

    //create second project
    await createProject('Shopping in Paris', 'EUR', driver);
    await ozzie.takeScreenshot('3_project_list');

    //remove second project
    await driver.scroll(find.byValueKey("project_1"), -400, 0,
        const Duration(milliseconds: 300));

    await ozzie.takeScreenshot('4_delete_project');
    await expectKeyPresent(Keys.deleteConfirmationDeleteButton, driver);
    await tapOnKey(Keys.deleteConfirmationDeleteButton, driver);

    //go to project details
    await tapOnText('Weekend trip', driver);
    await tapOnKey(Keys.projectDetailsUsersTab, driver);
    await ozzie.takeScreenshot('5_project_details');

    //add user
    await tapOnKey(Keys.projectDetailsAddUserButton, driver);
    await ozzie.takeScreenshot('6_add_user');
    await expectKeyPresent(Keys.userFormNameFieldKey, driver);
    await tapOnKey(Keys.userFormNameFieldKey, driver);
    await driver.enterText('John');
    await driver.waitFor(find.text('John'));

    await expectKeyPresent(Keys.userFormAddEditButtonKey, driver);
    await tapOnKey(Keys.userFormAddEditButtonKey, driver);
    await expectTextPresent('John', driver);

    //add more users
    await createUser('Kate', driver);
    await createUser('Bob', driver);
    await createUser('Andrew', driver);
    await ozzie.takeScreenshot('7_user_list');

    //go to expenses tab
    await tapOnKey(Keys.projectDetailsExpensesTab, driver);

    //create expense
    await tapOnKey(Keys.projectDetailsAddExpenseButton, driver);
    await ozzie.takeScreenshot('8_new_expense');
    await expectKeyPresent(Keys.expenseFormDescriptionFieldKey, driver);
    await tapOnKey(Keys.expenseFormDescriptionFieldKey, driver);
    await driver.enterText('Dinner');
    await driver.waitFor(find.text('Dinner'));

    await expectKeyPresent(Keys.expenseFormAcountFieldKey, driver);
    await tapOnKey(Keys.expenseFormAcountFieldKey, driver);
    await driver.enterText('50.24');
    await driver.waitFor(find.text('50.24'));

    await expectKeyPresent(Keys.expenseFormUserKey, driver);
    await tapOnKey(Keys.expenseFormUserKey, driver);
    await tapOnText('John', driver);

    await expectKeyPresent(Keys.expenseFormAddEditButtonKey, driver);
    await tapOnKey(Keys.expenseFormAddEditButtonKey, driver);

    await expectTextPresent('Dinner', driver);
    await expectTextPresent("John => Andrew, Bob, John, Kate", driver);
    await expectTextPresent('50.24', driver);

    await createExpense(
        "Evening beer", "26", "Bob", "Bob paid for Andrew, Bob, John, Kate", driver);

    await ozzie.takeScreenshot('9_expense_list');

    //go to report tab
    await tapOnKey(Keys.projectDetailsReportTab, driver);
    await ozzie.takeScreenshot('10_report');
  }, timeout: const Timeout(Duration(minutes: 5)));
}
