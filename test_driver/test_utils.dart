import 'package:costy/keys.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void testWithScreenshots(description, ozzieProvider, dynamic Function() body) {
  test(description, () async {
    try {
      await body();
      await ozzieProvider().takeScreenshot('SUCCESS_$description');
    } catch (e) {
      await ozzieProvider().takeScreenshot('ERROR_$description');
      throw e;
    }
  });
}

tapOnText(String text, FlutterDriver d) async {
  await d.tap(find.text(text), timeout: Duration(seconds: 2));
}

tapOnKey(String key, FlutterDriver d) async {
  await d.tap(find.byValueKey(key), timeout: Duration(seconds: 2));
}

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
  await tapOnKey(Keys.PROJECT_DETAILS_ADD_USER_BUTTON, d);

  await expectKeyPresent(Keys.USER_FORM_NAME_FIELD_KEY, d);
  await tapOnKey(Keys.USER_FORM_NAME_FIELD_KEY, d);
  await d.enterText(name);
  await d.waitFor(find.text(name));

  await expectKeyPresent(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY, d);
  await tapOnKey(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY, d);
  await expectTextPresent(name, d);
}

createProject(String name, String currency, FlutterDriver d) async {
  await tapOnKey(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY, d);

  await expectKeyPresent(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY, d);
  await tapOnKey(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY, d);
  await d.enterText(name);
  await d.waitFor(find.text(name));

  await expectKeyPresent(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY, d);
  await tapOnKey(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY, d);
  await tapOnText(currency, d);

  await expectKeyPresent(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY, d);
  await tapOnKey(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY, d);

  await expectTextPresent(name, d);
  await expectTextPresent(currency, d);
}

createExpense(String description, String amount, String user,
    String expectedSummary, FlutterDriver d) async {
  await tapOnKey(Keys.PROJECT_DETAILS_ADD_EXPENSE_BUTTON, d);

  await expectKeyPresent(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY, d);
  await tapOnKey(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY, d);
  await d.enterText(description);
  await d.waitFor(find.text(description));

  await expectKeyPresent(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY, d);
  await tapOnKey(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY, d);
  await d.enterText(amount);
  await d.waitFor(find.text(amount));

  await expectKeyPresent(Keys.EXPENSE_FORM_USER_KEY, d);
  await tapOnKey(Keys.EXPENSE_FORM_USER_KEY, d);
  await tapOnText(user, d);

  await expectKeyPresent(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY, d);
  await tapOnKey(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY, d);

  await expectTextPresent(description, d);
  await expectTextPresent(expectedSummary, d);
  await expectTextPresent(amount, d);
}
