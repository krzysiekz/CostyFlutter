import 'package:costy/keys.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

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

createUser(String name, FlutterDriver d) async {
  await d.tap(find.byValueKey(Keys.PROJECT_DETAILS_ADD_USER_BUTTON));
  await expectPresent(
    find.byValueKey(Keys.USER_FORM_NAME_FIELD_KEY),
    d,
    objectName: Keys.USER_FORM_NAME_FIELD_KEY,
  );
  await d.tap(find.byValueKey(Keys.USER_FORM_NAME_FIELD_KEY));
  await d.enterText(name);
  await d.waitFor(find.text(name));

  await expectPresent(
    find.byValueKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY),
    d,
    objectName: Keys.USER_FORM_ADD_EDIT_BUTTON_KEY,
  );
  await d.tap(find.byValueKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY));
  await expectPresent(find.text(name), d, objectName: name);
}

createProject(String name, String currency, FlutterDriver d) async {
  var projectNameTextFormFieldFinder =
      find.byValueKey(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY);

  await d.tap(find.byValueKey(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY));

  await expectPresent(
    projectNameTextFormFieldFinder,
    d,
    objectName: Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY,
  );
  await d.tap(projectNameTextFormFieldFinder);
  await d.enterText(name);
  await d.waitFor(find.text(name));

  await expectPresent(
    find.byValueKey(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY),
    d,
    objectName: Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY,
  );
  await d.tap(find.byValueKey(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY));
  await d.tap(find.text(currency));

  await expectPresent(
    find.byValueKey(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY),
    d,
    objectName: Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY,
  );
  await d.tap(find.byValueKey(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY));

  await expectPresent(find.text(name), d, objectName: name);
  await expectPresent(find.text(currency), d, objectName: currency);
}
