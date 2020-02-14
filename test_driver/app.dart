import 'package:costy/main.dart' as app;
import 'package:costy/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() async {
  enableFlutterDriverExtension();

  await app.initializeApp();
  runApp(MyApp());
}
