// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RadioEntityAdapter extends TypeAdapter<RadioEntity> {
  @override
  final int typeId = 2;

  @override
  RadioEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RadioEntity(
      id: fields[0] as num?,
      name: fields[1] as String?,
      url: fields[2] as String?,
      recentDate: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RadioEntity obj) {
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
      other is RadioEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
