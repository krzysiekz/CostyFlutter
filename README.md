# Costy - group expenses managing app written in Flutter <!-- omit in toc -->

This is a rework of an Android app I wrote some time ago. This time written in Flutter and improved. I used it as my Flutter playground.

- [Functionality](#functionality)
- [Some screenshots](#some-screenshots)
  - [Android light theme](#android-light-theme)
  - [Android dark theme](#android-dark-theme)
  - [IOS](#ios)
- [Some technical details](#some-technical-details)

## Functionality

- Add/modify/delete projects, people and expenses
- Generate and share expense report
- Multi-language (currently Polish and English)
- Support for dark/light theme (Android only)
- Work on IOS, Android and Web (although it was not really adjusted to proper Web experience)
- Adaptive look for Android and IOS

## Some screenshots

### Android light theme

<p float="left">
<img src="docs/screenshots/android/light/2020-05-06T17:10:16.842374-1_no_projects.png" width="290">
<img src="docs/screenshots/android/light/2020-05-06T17:10:19.268956-2_add_projects.png" width="290">
<img src="docs/screenshots/android/light/2020-05-06T17:10:24.526346-3_project_list.png" width="290">
</p>

<p float="left">
<img src="docs/screenshots/android/light/2020-05-06T17:10:27.147336-4_delete_project.png" width="290">
<img src="docs/screenshots/android/light/2020-05-06T17:10:30.191732-5_project_details.png" width="290">
<img src="docs/screenshots/android/light/2020-05-06T17:10:32.455253-6_add_user.png" width="290">
</p>

<p float="left">
<img src="docs/screenshots/android/light/2020-05-06T17:10:38.242545-7_user_list.png" width="290">
<img src="docs/screenshots/android/light/2020-05-06T17:10:40.731465-8_new_expense.png" width="290">
<img src="docs/screenshots/android/light/2020-05-06T17:10:46.503347-9_expense_list.png" width="290">
<img src="docs/screenshots/android/light/2020-05-06T17:10:49.022152-10_report.png" width="290">
</p>

### Android dark theme
<p float="left">
<img src="docs/screenshots/android/dark/2020-05-06T17:08:25.219964-1_no_projects.png" width="290">
<img src="docs/screenshots/android/dark/2020-05-06T17:08:27.734895-2_add_projects.png" width="290">
<img src="docs/screenshots/android/dark/2020-05-06T17:08:33.526171-3_project_list.png" width="290">
</p>

<p float="left">
<img src="docs/screenshots/android/dark/2020-05-06T17:08:36.167415-4_delete_project.png" width="290">
<img src="docs/screenshots/android/dark/2020-05-06T17:08:39.231693-5_project_details.png" width="290">
<img src="docs/screenshots/android/dark/2020-05-06T17:08:41.499935-6_add_user.png" width="290">
</p>

<p float="left">
<img src="docs/screenshots/android/dark/2020-05-06T17:08:47.392873-7_user_list.png" width="290">
<img src="docs/screenshots/android/dark/2020-05-06T17:08:49.927106-8_new_expense.png" width="290">
<img src="docs/screenshots/android/dark/2020-05-06T17:08:55.701346-9_expense_list.png" width="290">
<img src="docs/screenshots/android/dark/2020-05-06T17:08:57.977149-10_report.png" width="290">
</p>

### IOS

<p float="left">
<img src="docs/screenshots/ios/2020-05-05T18:09:08.234778-1_no_projects.png" width="290">
<img src="docs/screenshots/ios/2020-05-05T18:09:10.898224-2_add_projects.png" width="290">
<img src="docs/screenshots/ios/2020-05-05T18:09:18.827792-3_project_list.png" width="290">
</p>

<p float="left">
<img src="docs/screenshots/ios/2020-05-05T18:09:21.970749-4_delete_project.png" width="290">
<img src="docs/screenshots/ios/2020-05-05T18:09:25.601664-5_project_details.png" width="290">
<img src="docs/screenshots/ios/2020-05-05T18:09:28.145722-6_add_user.png" width="290">
</p>

<p float="left">
<img src="docs/screenshots/ios/2020-05-05T18:09:36.214770-7_user_list.png" width="290">
<img src="docs/screenshots/ios/2020-05-05T18:09:38.664195-8_new_expense.png" width="290">
<img src="docs/screenshots/ios/2020-05-05T18:09:46.988608-9_expense_list.png" width="290">
<img src="docs/screenshots/ios/2020-05-05T18:09:49.585117-10_report.png" width="290">
</p>

## Some technical details
- I used Hive for data persistence
- I used BloC for state management
- I used get_it package as service locator / dependency injection tool
- Logic fully covered in unit tests
- Widgets and Integration tests also in place when needed
- Integration with Ozzie for taking screenshots during integration tests