import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'project_entity.g.dart';

@HiveType()
class ProjectEntity extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String defaultCurrency;

  ProjectEntity({
    @required this.name,
    @required this.defaultCurrency,
  });

  @override
  List<Object> get props => [name, defaultCurrency];
}
