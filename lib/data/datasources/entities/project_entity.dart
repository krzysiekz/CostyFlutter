import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'project_entity.g.dart';

@HiveType(typeId: 1)
class ProjectEntity extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String defaultCurrency;

  @HiveField(2)
  final String creationDateTime;

  const ProjectEntity(
      {@required this.name,
      @required this.defaultCurrency,
      @required this.creationDateTime});

  @override
  List<Object> get props => [name, defaultCurrency];
}
