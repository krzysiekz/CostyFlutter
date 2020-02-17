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

  test('check flutter driver health', () async {
    final health = await driver.checkHealth();
    expect(health.status, HealthStatus.ok);
    print(health.status);
  });

  test('should display proper text when there is no projects yet', () async {
    await driver.waitFor(find.text('No projects to display.'));
  });

  test('should display add new project form when button clicked', () async {
    await driver.tap(find.byValueKey(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY));
    await driver
        .waitFor(find.byValueKey(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY));
    await driver
        .waitFor(find.byValueKey(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY));
    await driver
        .waitFor(find.byValueKey(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY));
  });
}
