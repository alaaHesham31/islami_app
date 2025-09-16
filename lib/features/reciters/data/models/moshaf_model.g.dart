// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moshaf_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoshafModelAdapter extends TypeAdapter<MoshafModel> {
  @override
  final int typeId = 1;

  @override
  MoshafModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoshafModel(
      moshafId: fields[0] as int,
      moshafName: fields[1] as String,
      serverUrl: fields[2] as String,
      surahList: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MoshafModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.moshafId)
      ..writeByte(1)
      ..write(obj.moshafName)
      ..writeByte(2)
      ..write(obj.serverUrl)
      ..writeByte(3)
      ..write(obj.surahList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoshafModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
