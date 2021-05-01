// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_day_list_rel_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskDayListRelAdapter extends TypeAdapter<TaskDayListRel> {
  @override
  final int typeId = 5;

  @override
  TaskDayListRel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskDayListRel()
      ..listId = fields[0] as int
      ..taskId = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, TaskDayListRel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.listId)
      ..writeByte(1)
      ..write(obj.taskId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDayListRelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
