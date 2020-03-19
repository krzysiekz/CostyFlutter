// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectEntityAdapter extends TypeAdapter<ProjectEntity> {
  @override
  final typeId = 1;

  @override
  ProjectEntity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
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
}
