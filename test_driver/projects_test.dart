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

  test('should display proper text when there is no projects yet', () async {
    await expectTextPresent("No projects to display.", driver);
  });

  test('should add new project', () async {
    await createProject("Project1", "PLN", driver);
  });

  test('should edit created project', () async {
    await driver.tap(find.byValueKey("0_project_edit"));

    await expectKeyPresent(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY, driver);
    await driver.tap(find.byValueKey(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY));
    await driver.enterText('Project2');
    await driver.waitFor(find.text('Project2'));

    await expectKeyPresent(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY, driver);
    await driver.tap(find.byValueKey(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY));
    await driver.tap(find.text('EUR'));

    await expectKeyPresent(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY, driver);
    await driver.tap(find.byValueKey(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY));

    await expectTextPresent("Project2", driver);
    await expectTextPresent("EUR", driver);
  });

  test('should delete created project', () async {
    await driver.scroll(
        find.byValueKey("project_0"), -400, 0, Duration(milliseconds: 300));

    await expectKeyPresent(Keys.DELETE_CONFIRMATION_DELETE_BUTTON, driver);
    await driver.tap(find.byValueKey(Keys.DELETE_CONFIRMATION_DELETE_BUTTON));

    await expectTextPresent("No projects to display.", driver);
  });
}
