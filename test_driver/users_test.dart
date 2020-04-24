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

    var textToFind = 'No users to display.';
    await expectPresent(find.text(textToFind), driver, objectName: textToFind);
  });

  test('should add new user', () async {
    await createUser('John', driver);
  });

  test('should edit created user', () async {
    await driver.tap(find.byValueKey("0_user_edit"));

    await expectPresent(
      find.byValueKey(Keys.USER_FORM_NAME_FIELD_KEY),
      driver,
      objectName: Keys.USER_FORM_NAME_FIELD_KEY,
    );
    await driver.tap(find.byValueKey(Keys.USER_FORM_NAME_FIELD_KEY));
    await driver.enterText('Edited John');
    await driver.waitFor(find.text('Edited John'));

    await expectPresent(
      find.byValueKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY),
      driver,
      objectName: Keys.USER_FORM_ADD_EDIT_BUTTON_KEY,
    );
    await driver.tap(find.byValueKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY));

    await expectPresent(find.text('Edited John'), driver,
        objectName: 'Edited John');
  });

  test('should delete created user', () async {
    await driver.scroll(
        find.byValueKey("user_0"), -400, 0, Duration(milliseconds: 300));

    await expectPresent(
        find.byValueKey(Keys.DELETE_CONFIRMATION_DELETE_BUTTON), driver,
        objectName: Keys.DELETE_CONFIRMATION_DELETE_BUTTON,
        timeout: Duration(seconds: 2));

    await driver.tap(find.byValueKey(Keys.DELETE_CONFIRMATION_DELETE_BUTTON));

    var textToFind = 'No users to display.';
    await expectPresent(find.text(textToFind), driver, objectName: textToFind);
  });
}
