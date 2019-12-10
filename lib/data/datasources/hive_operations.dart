import 'package:hive/hive.dart';

abstract class HiveOperations {
  Future<Box> openBox(String boxName);
}
