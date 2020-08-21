import 'package:equatable/equatable.dart';

import '../../data/models/currency.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();
}

class CurrencyEmpty extends CurrencyState {
  @override
  List<Object> get props => [];
}

class CurrencyLoading extends CurrencyState {
  @override
  List<Object> get props => [];
}

class CurrencyLoaded extends CurrencyState {
  final List<Currency> currencies;

  const CurrencyLoaded(this.currencies);

  @override
  List<Object> get props => [currencies];
}

class CurrencyError extends CurrencyState {
  final String errorMessage;

  const CurrencyError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
