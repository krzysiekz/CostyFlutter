import 'dart:io';

import 'package:costy/keys.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

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

  expectPresent(
    SerializableFinder byValueKey,
    FlutterDriver driver, {
    Duration timeout = const Duration(seconds: 1),
    String objectName,
  }) async {
    try {
      await driver.waitFor(byValueKey, timeout: timeout);
    } catch (exception) {
      throw TestFailure("Element not found: " + objectName);
    }
  }

  test('check flutter driver health', () async {
    final health = await driver.checkHealth();
    expect(health.status, HealthStatus.ok);
    print(health.status);
  });

  test('should display proper text when there is no users yet', () async {
    var projectNameTextFormFieldFinder =
        find.byValueKey(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY);

    await driver.tap(find.byValueKey(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY));

    await expectPresent(
      projectNameTextFormFieldFinder,
      driver,
      objectName: Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY,
    );
    await driver.tap(projectNameTextFormFieldFinder);
    await driver.enterText('Project1');
    await driver.waitFor(find.text('Project1'));

    await expectPresent(
      find.byValueKey(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY),
      driver,
      objectName: Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY,
    );
    await driver.tap(find.byValueKey(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY));
    await driver.tap(find.text('PLN'));

    await expectPresent(
      find.byValueKey(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY),
      driver,
      objectName: Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY,
    );
    await driver.tap(find.byValueKey(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY));

    await expectPresent(find.text('Project1'), driver, objectName: 'Project1');
    await expectPresent(find.text('PLN'), driver, objectName: 'PLN');

    await driver.tap(find.text('Project1'));
    await driver.tap(find.byValueKey(Keys.PROJECT_DETAILS_USERS_TAB));

    var textToFind = 'No users to display.';
    await expectPresent(find.text('No users to display.'), driver,
        objectName: textToFind);
  });

  test('should add new user', () async {
    await driver.tap(find.byValueKey(Keys.PROJECT_DETAILS_ADD_USER_BUTTON));

    await expectPresent(
      find.byValueKey(Keys.USER_FORM_NAME_FIELD_KEY),
      driver,
      objectName: Keys.USER_FORM_NAME_FIELD_KEY,
    );
    await driver.tap(find.byValueKey(Keys.USER_FORM_NAME_FIELD_KEY));
    await driver.enterText('John');
    await driver.waitFor(find.text('John'));

    await expectPresent(
      find.byValueKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY),
      driver,
      objectName: Keys.USER_FORM_ADD_EDIT_BUTTON_KEY,
    );
    await driver.tap(find.byValueKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY));

    await expectPresent(find.text('John'), driver, objectName: 'John');
  });
}
