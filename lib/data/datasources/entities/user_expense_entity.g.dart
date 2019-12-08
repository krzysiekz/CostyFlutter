// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_expense_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserExpenseAdapter extends TypeAdapter<UserExpense> {
  @override
  UserExpense read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserExpense(
      receiversIds: (fields[0] as List)?.cast<int>(),
      userId: fields[1] as int,
      amount: fields[2] as Decimal,
      description: fields[3] as String,
      currency: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserExpense obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.receiversIds)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.currency);
  }
}
