// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reciter_model.dart';

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
      reciterId: fields[0] as int,
      reciterName: fields[1] as String,
      moshafModels: (fields[2] as List).cast<MoshafModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReciterModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.reciterId)
      ..writeByte(1)
      ..write(obj.reciterName)
      ..writeByte(2)
      ..write(obj.moshafModels);
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
