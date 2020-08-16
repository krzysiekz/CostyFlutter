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
  await d.tap(find.text(text), timeout: const Duration(seconds: 2));
}

tapOnKey(String key, FlutterDriver d) async {
  await d.tap(find.byValueKey(key), timeout: const Duration(seconds: 2));
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
  await tapOnKey(Keys.projectDetailsAddUserButton, d);

  await expectKeyPresent(Keys.userFormNameFieldKey, d);
  await tapOnKey(Keys.userFormNameFieldKey, d);
  await d.enterText(name);
  await d.waitFor(find.text(name));

  await expectKeyPresent(Keys.userFormAddEditButtonKey, d);
  await tapOnKey(Keys.userFormAddEditButtonKey, d);
  await expectTextPresent(name, d);
}

createProject(String name, String currency, FlutterDriver d) async {
  await tapOnKey(Keys.projectlistAddProjectButtonKey, d);

  await expectKeyPresent(Keys.projectFormProjectNameFieldKey, d);
  await tapOnKey(Keys.projectFormProjectNameFieldKey, d);
  await d.enterText(name);
  await d.waitFor(find.text(name));

  await expectKeyPresent(Keys.projectFormDefaultCurrencyKey, d);
  await tapOnKey(Keys.projectFormDefaultCurrencyKey, d);
  await tapOnText(currency, d);

  await expectKeyPresent(Keys.projectFormAddEditButtonKey, d);
  await tapOnKey(Keys.projectFormAddEditButtonKey, d);

  await expectTextPresent(name, d);
  await expectTextPresent(currency, d);
}

createExpense(String description, String amount, String user,
    String expectedSummary, FlutterDriver d) async {
  await tapOnKey(Keys.projectDetailsAddExpenseButton, d);

  await expectKeyPresent(Keys.expenseFormDescriptionFieldKey, d);
  await tapOnKey(Keys.expenseFormDescriptionFieldKey, d);
  await d.enterText(description);
  await d.waitFor(find.text(description));

  await expectKeyPresent(Keys.expenseFormAcountFieldKey, d);
  await tapOnKey(Keys.expenseFormAcountFieldKey, d);
  await d.enterText(amount);
  await d.waitFor(find.text(amount));

  await expectKeyPresent(Keys.expenseFormUserKey, d);
  await tapOnKey(Keys.expenseFormUserKey, d);
  await tapOnText(user, d);

  await expectKeyPresent(Keys.expenseFormAddEditButtonKey, d);
  await tapOnKey(Keys.expenseFormAddEditButtonKey, d);

  await expectTextPresent(description, d);
  await expectTextPresent(expectedSummary, d);
  await expectTextPresent(amount, d);
}
