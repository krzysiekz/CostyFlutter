import 'package:costy/keys.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

expectKeyPresent(String key, FlutterDriver driver) async {
  await expectPresent(find.byValueKey(key), driver, objectName: key);
}

expectTextPresent(String text, FlutterDriver driver) async {
  await expectPresent(find.text(text), driver, objectName: text);
}

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

  await expectKeyPresent(Keys.USER_FORM_NAME_FIELD_KEY, d);
  await d.tap(find.byValueKey(Keys.USER_FORM_NAME_FIELD_KEY));
  await d.enterText(name);
  await d.waitFor(find.text(name));

  await expectKeyPresent(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY, d);
  await d.tap(find.byValueKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY));
  await expectTextPresent(name, d);
}

createProject(String name, String currency, FlutterDriver d) async {
  await d.tap(find.byValueKey(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY));

  await expectKeyPresent(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY, d);
  await d.tap(find.byValueKey(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY));
  await d.enterText(name);
  await d.waitFor(find.text(name));

  await expectKeyPresent(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY, d);
  await d.tap(find.byValueKey(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY));
  await d.tap(find.text(currency));

  await expectKeyPresent(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY, d);
  await d.tap(find.byValueKey(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY));

  await expectTextPresent(name, d);
  await expectTextPresent(currency, d);
}
