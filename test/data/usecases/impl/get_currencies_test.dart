import 'package:costy/data/models/currency.dart';
import 'package:costy/data/repositories/currencies_repository.dart';
import 'package:costy/data/usecases/impl/get_currencies.dart';
import 'package:costy/data/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCurrenciesRepository extends Mock implements CurrenciesRepository {}

void main() {
  GetCurrencies getCurrencies;
  MockCurrenciesRepository mockCurrenciesRepository;

  setUp(() {
    mockCurrenciesRepository = MockCurrenciesRepository();
    getCurrencies =
        GetCurrencies(currenciesRepository: mockCurrenciesRepository);
  });

  final tCurrencyList = [
    Currency(name: 'USD'),
    Currency(name: 'PLN'),
  ];

  test('should get currencies from the repository', () async {
    //arrange
    when(mockCurrenciesRepository.getCurrencies())
        .thenAnswer((_) async => Right(tCurrencyList));
    //act
    final result = await getCurrencies.call(NoParams());
    //assert
    expect(result, Right(tCurrencyList));
    verify(mockCurrenciesRepository.getCurrencies());
    verifyNoMoreInteractions(mockCurrenciesRepository);
  });
}
