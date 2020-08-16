// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectEntityAdapter extends TypeAdapter<ProjectEntity> {
  @override
  final int typeId = 1;

  @override
  ProjectEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectEntity(
      name: fields[0] as String,
      defaultCurrency: fields[1] as String,
      creationDateTime: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.defaultCurrency)
      ..writeByte(2)
      ..write(obj.creationDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
