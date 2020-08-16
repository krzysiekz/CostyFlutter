import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../../injection.dart';
import '../hive_operations.dart';

@Singleton(as: HiveOperations, env: [Env.prod])
class HiveOperationsImpl implements HiveOperations {

  @override
  Future<Box> openBox(String boxName) {
    return Hive.openBox(boxName);
  }
}