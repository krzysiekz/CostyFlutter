import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'user_entity.g.dart';

@HiveType()
class UserEntity {
  @HiveField(0)
  final String name;

  UserEntity({@required this.name});
}
