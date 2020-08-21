import 'package:bloc_test/bloc_test.dart';
import 'package:costy/data/errors/failures.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/usecases/impl/get_currencies.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/bloc/currency_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetCurrencies extends Mock implements GetCurrencies {}

void main() {
  MockGetCurrencies mockGetCurrencies;

  setUp(() {
    mockGetCurrencies = MockGetCurrencies();
  });

  const tCurrencyList = [
    Currency(name: 'USD'),
    Currency(name: 'PLN'),
  ];

  blocTest('should emit proper states when getting currencies',
      skip: 0,
      build: () {
        when(mockGetCurrencies.call(any))
            .thenAnswer((_) async => const Right(tCurrencyList));
        return CurrencyBloc(mockGetCurrencies);
      },
      act: (bloc) => bloc.add(GetCurrenciesEvent()),
      expect: [CurrencyLoading(), const CurrencyLoaded(tCurrencyList)]);

  blocTest('should emit proper states in case or error',
      build: () {
        when(mockGetCurrencies.call(any))
            .thenAnswer((_) async => Left(DataSourceFailure()));
        return CurrencyBloc(mockGetCurrencies);
      },
      act: (bloc) => bloc.add(GetCurrenciesEvent()),
      expect: [
        CurrencyLoading(),
        const CurrencyError(datasouceFailureMessage)
      ]);
}
