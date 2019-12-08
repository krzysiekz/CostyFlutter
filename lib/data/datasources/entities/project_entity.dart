import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'project_entity.g.dart';

@HiveType()
class ProjectEntity {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String defaultCurrency;

  ProjectEntity({
    @required this.name,
    @required this.defaultCurrency,
  });
}
