// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_expense_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserExpenseEntityAdapter extends TypeAdapter<UserExpenseEntity> {
  @override
  final int typeId = 3;

  @override
  UserExpenseEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserExpenseEntity(
      receiversIds: (fields[0] as List)?.cast<int>(),
      userId: fields[1] as int,
      amount: fields[2] as String,
      description: fields[3] as String,
      currency: fields[4] as String,
      projectId: fields[5] as int,
      dateTime: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserExpenseEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.receiversIds)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.projectId)
      ..writeByte(6)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserExpenseEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
