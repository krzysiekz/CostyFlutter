import 'package:costy/data/datasources/entities/currency_entity.dart';
import 'package:costy/data/datasources/hive_operations.dart';
import 'package:costy/data/datasources/impl/currencies_datasource_impl.dart';
import 'package:costy/data/models/currency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

class MockHiveOperations extends Mock implements HiveOperations {}

class MockBox extends Mock implements Box {}

void main() {
  CurrenciesDataSourceImpl dataSource;
  MockHiveOperations mockHiveOperations;
  MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    mockHiveOperations = MockHiveOperations();
    dataSource = CurrenciesDataSourceImpl(mockHiveOperations);
  });

  final tCurrencyEntities = {
    0: CurrencyEntity(name: 'USD'),
    1: CurrencyEntity(name: 'EUR'),
  };

  final tCurrencyList = [
    Currency(name: 'USD'),
    Currency(name: 'EUR'),
  ];

  test('should return list of currencies', () async {
    //arrange
    when(mockHiveOperations.openBox(any)).thenAnswer((_) async => mockBox);
    when(mockBox.toMap()).thenReturn(tCurrencyEntities);
    //act
    final currencies = await dataSource.getCurrencies();
    //assert
    expect(currencies, tCurrencyList);

    verify(mockHiveOperations.openBox('currencies'));
    verifyNoMoreInteractions(mockHiveOperations);

    verify(mockBox.toMap());
    verifyNoMoreInteractions(mockBox);
  });
}
