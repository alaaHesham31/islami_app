import 'package:hive/hive.dart';

part 'DownloadedSurahModel.g.dart';

@HiveType(typeId: 3)
class DownloadedSurahModel {
  @HiveField(0)
  final int reciterId;


  @HiveField(1)
  final int surahId;


  @HiveField(2)
  final String localPath;


  @HiveField(3)
  final bool isDownloaded;


  DownloadedSurahModel({
    required this.reciterId,
    required this.surahId,
    required this.localPath,
    this.isDownloaded = true,
  });


  factory DownloadedSurahModel.fromEntity(entity) => DownloadedSurahModel(
    reciterId: entity.reciterId,
    surahId: entity.surahId,
    localPath: entity.localPath,
    isDownloaded: entity.isDownloaded,
  );


// Convert back to a domain-like map (not strictly necessary)
}
