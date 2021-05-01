// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_tag_rel_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskTagRelAdapter extends TypeAdapter<TaskTagRel> {
  @override
  final int typeId = 2;

  @override
  TaskTagRel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskTagRel()
      ..taskId = fields[0] as int
      ..tagId = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, TaskTagRel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.tagId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskTagRelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
