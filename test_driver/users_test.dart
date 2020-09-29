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

  testWithScreenshots(
      'should display proper text when there is no users yet', () => ozzie,
      () async {
    await createProject("Project1", "PLN", driver);

    await tapOnText('Project1', driver);
    await tapOnKey(Keys.projectDetailsUsersTab, driver);

    await expectTextPresent("No users to display.", driver);
  });

  testWithScreenshots('should add new user', () => ozzie, () async {
    await createUser('John', driver);
  });

  testWithScreenshots('should edit created user', () => ozzie, () async {
    await tapOnKey("edit_user_0", driver);

    await expectKeyPresent(Keys.userFormNameFieldKey, driver);
    await tapOnKey(Keys.userFormNameFieldKey, driver);
    await driver.enterText('Edited John');
    await driver.waitFor(find.text('Edited John'));

    await expectKeyPresent(Keys.userFormAddEditButtonKey, driver);
    await tapOnKey(Keys.userFormAddEditButtonKey, driver);

    await expectTextPresent("Edited John", driver);
  });

  testWithScreenshots('should delete created user', () => ozzie, () async {
    await tapOnKey("delete_user_0", driver);

    await expectKeyPresent(Keys.deleteConfirmationDeleteButton, driver);
    await tapOnKey(Keys.deleteConfirmationDeleteButton, driver);

    await expectTextPresent("No users to display.", driver);
  });
}
