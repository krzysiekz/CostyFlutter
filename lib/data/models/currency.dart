import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Currency extends Equatable {
  final String name;

  const Currency({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() {
    return "Currency[name: $name]";
  }
}
