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

  test('should display proper text when there is no users yet', () async {
    await createProject("Project1", "PLN", driver);

    await driver.tap(find.text('Project1'));
    await driver.tap(find.byValueKey(Keys.PROJECT_DETAILS_USERS_TAB));

    await expectTextPresent("No users to display.", driver);
  });

  test('should add new user', () async {
    await createUser('John', driver);
  });

  test('should edit created user', () async {
    await driver.tap(find.byValueKey("0_user_edit"));

    await expectKeyPresent(Keys.USER_FORM_NAME_FIELD_KEY, driver);
    await driver.tap(find.byValueKey(Keys.USER_FORM_NAME_FIELD_KEY));
    await driver.enterText('Edited John');
    await driver.waitFor(find.text('Edited John'));

    await expectKeyPresent(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY, driver);
    await driver.tap(find.byValueKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY));

    await expectTextPresent("Edited John", driver);
  });

  test('should delete created user', () async {
    await driver.scroll(
        find.byValueKey("user_0"), -400, 0, Duration(milliseconds: 300));

    await expectKeyPresent(Keys.DELETE_CONFIRMATION_DELETE_BUTTON, driver);
    await driver.tap(find.byValueKey(Keys.DELETE_CONFIRMATION_DELETE_BUTTON));

    await expectTextPresent("No users to display.", driver);
  });
}
