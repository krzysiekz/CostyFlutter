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
    ozzie = Ozzie.initWith(driver, groupName: 'users');
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

  testWithScreenshots(
      'should display proper text when there is no users yet', () => ozzie,
      () async {
    await createProject("Project1", "PLN", driver);

    await tapOnText('Project1', driver);
    await tapOnKey(Keys.PROJECT_DETAILS_USERS_TAB, driver);

    await expectTextPresent("No users to display.", driver);
  });

  testWithScreenshots('should add new user', () => ozzie, () async {
    await createUser('John', driver);
  });

  testWithScreenshots('should edit created user', () => ozzie, () async {
    await tapOnKey("0_user_edit", driver);

    await expectKeyPresent(Keys.USER_FORM_NAME_FIELD_KEY, driver);
    await tapOnKey(Keys.USER_FORM_NAME_FIELD_KEY, driver);
    await driver.enterText('Edited John');
    await driver.waitFor(find.text('Edited John'));

    await expectKeyPresent(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY, driver);
    await tapOnKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY, driver);

    await expectTextPresent("Edited John", driver);
  });

  testWithScreenshots('should delete created user', () => ozzie, () async {
    await driver.scroll(
        find.byValueKey("user_0"), -400, 0, Duration(milliseconds: 300));

    await expectKeyPresent(Keys.DELETE_CONFIRMATION_DELETE_BUTTON, driver);
    await tapOnKey(Keys.DELETE_CONFIRMATION_DELETE_BUTTON, driver);

    await expectTextPresent("No users to display.", driver);
  });
}
