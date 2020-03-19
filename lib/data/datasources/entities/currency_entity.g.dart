// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyEntityAdapter extends TypeAdapter<CurrencyEntity> {
  @override
  final typeId = 0;

  @override
  CurrencyEntity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyEntity(
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }
}
