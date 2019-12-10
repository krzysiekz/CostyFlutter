import 'package:costy/data/datasources/hive_operations.dart';
import 'package:hive/hive.dart';

class HiveOperationsImpl implements HiveOperations {

  @override
  Future<Box> openBox(String boxName) {
    return Hive.openBox(boxName);
  }
}