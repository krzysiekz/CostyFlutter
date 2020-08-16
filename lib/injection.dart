import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final ic = GetIt.instance;

@injectableInit
void configureInjection(String environment) =>
    $initGetIt(ic, environment: environment);

abstract class Env {
  static const prod = 'prod';
}
