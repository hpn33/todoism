// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_list_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayListAdapter extends TypeAdapter<DayList> {
  @override
  final int typeId = 4;

  @override
  DayList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayList()..date = fields[0] as DateTime;
  }

  @override
  void write(BinaryWriter writer, DayList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
