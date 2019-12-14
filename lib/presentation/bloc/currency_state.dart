import 'package:equatable/equatable.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();
}

class InitialCurrencyState extends CurrencyState {
  @override
  List<Object> get props => [];
}
