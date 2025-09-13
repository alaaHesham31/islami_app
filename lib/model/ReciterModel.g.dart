// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReciterModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReciterModelAdapter extends TypeAdapter<ReciterModel> {
  @override
  final int typeId = 0;

  @override
  ReciterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReciterModel(
      id: fields[0] as int,
      name: fields[1] as String,
      moshaf: (fields[2] as List).cast<MoshafModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReciterModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.moshaf);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReciterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      id: fields[0] as int,
      name: fields[1] as String,
      server: fields[2] as String,
      surahList: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MoshafModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.server)
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
