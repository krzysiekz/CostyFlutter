import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final int id;
  final String name;

  User({@required this.id, @required this.name});

  @override
  List<Object> get props => [id, name];

  @override
  String toString() {
    return "User[id: $id, name: $name]";
  }
}
