import 'package:hive/hive.dart';

part 'DownloadedSurahModel.g.dart';

@HiveType(typeId: 3)
class DownloadedSurah {
  @HiveField(0)
  final int reciterId;

  @HiveField(1)
  final int surahId;

  @HiveField(2)
  final String localPath;

  @HiveField(3)
  final bool isDownloaded;

  DownloadedSurah({
    required this.reciterId,
    required this.surahId,
    required this.localPath,
    this.isDownloaded = true,
  });
}
