import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'user_entity.g.dart';

@HiveType(typeId: 2)
class UserEntity extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int projectId;

  UserEntity({@required this.name, @required this.projectId});

  @override
  List<Object> get props => [name, projectId];
}
