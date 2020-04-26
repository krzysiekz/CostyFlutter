import 'package:costy/keys.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

expectKeyPresent(String key, FlutterDriver d) async {
  await expectPresent(find.byValueKey(key), d, objectName: key);
}

expectTextPresent(String text, FlutterDriver d) async {
  await expectPresent(find.text(text), d, objectName: text);
}

expectPresent(
  SerializableFinder byValueKey,
  FlutterDriver d, {
  Duration timeout = const Duration(seconds: 1),
  String objectName,
}) async {
  try {
    await d.waitFor(byValueKey, timeout: timeout);
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

createExpense(String description, String amount, String user,
    String expectedSummary, FlutterDriver d) async {
  await d.tap(find.byValueKey(Keys.PROJECT_DETAILS_ADD_EXPENSE_BUTTON));

  await expectKeyPresent(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY, d);
  await d.tap(find.byValueKey(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY));
  await d.enterText(description);
  await d.waitFor(find.text(description));

  await expectKeyPresent(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY, d);
  await d.tap(find.byValueKey(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY));
  await d.enterText(amount);
  await d.waitFor(find.text(amount));

  await expectKeyPresent(Keys.EXPENSE_FORM_USER_KEY, d);
  await d.tap(find.byValueKey(Keys.EXPENSE_FORM_USER_KEY));
  await d.tap(find.text(user));

  await expectKeyPresent(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY, d);
  await d.tap(find.byValueKey(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY));

  await expectTextPresent(description, d);
  await expectTextPresent(expectedSummary, d);
  await expectTextPresent(amount, d);
}
