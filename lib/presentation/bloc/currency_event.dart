import 'package:equatable/equatable.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();
}

class GetCurrenciesEvent extends CurrencyEvent {
  @override
  List<Object> get props => [];
}
