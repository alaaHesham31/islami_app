// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DownloadedSurahModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadedSurahAdapter extends TypeAdapter<DownloadedSurahModel> {
  @override
  final int typeId = 3;

  @override
  DownloadedSurahModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedSurahModel(
      reciterId: fields[0] as int,
      surahId: fields[1] as int,
      localPath: fields[2] as String,
      isDownloaded: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedSurahModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.reciterId)
      ..writeByte(1)
      ..write(obj.surahId)
      ..writeByte(2)
      ..write(obj.localPath)
      ..writeByte(3)
      ..write(obj.isDownloaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedSurahAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
