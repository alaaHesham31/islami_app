// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RadioResponseModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RadiosModelAdapter extends TypeAdapter<RadiosModel> {
  @override
  final int typeId = 2;

  @override
  RadiosModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RadiosModel(
      id: fields[0] as num?,
      name: fields[1] as String?,
      url: fields[2] as String?,
      recentDate: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RadiosModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.recentDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadiosModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
