import 'package:costy/data/datasources/currencies_datasource.dart';
import 'package:costy/data/errors/exceptions.dart';
import 'package:costy/data/errors/failures.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/repositories/impl/currencies_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCurrenciesDataSource extends Mock implements CurrenciesDataSource {}

void main() {
  CurrenciesRepositoryImpl repository;
  MockCurrenciesDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockCurrenciesDataSource();
    repository = CurrenciesRepositoryImpl(mockDataSource);
  });

  final tCurrencyList = [
    const Currency(name: 'USD'),
    const Currency(name: 'PLN'),
  ];

  test('should return currencies from data source', () async {
    //arrange
    when(mockDataSource.getCurrencies()).thenAnswer((_) async => tCurrencyList);
    //act
    final result = await repository.getCurrencies();
    //assert
    expect(result, Right(tCurrencyList));
    verify(mockDataSource.getCurrencies());
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should return failure when exception occurs during query', () async {
    //arrange
    when(mockDataSource.getCurrencies()).thenThrow(DataSourceException());
    //act
    final result = await repository.getCurrencies();
    //assert
    expect(result, Left(DataSourceFailure()));
    verify(mockDataSource.getCurrencies());
    verifyNoMoreInteractions(mockDataSource);
  });
}
