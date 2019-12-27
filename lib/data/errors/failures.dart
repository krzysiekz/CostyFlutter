import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class DataSourceFailure extends Failure {
  @override
  List<Object> get props => [];
}

class ReportGenerationFailure extends Failure {
  @override
  List<Object> get props => [];
}
