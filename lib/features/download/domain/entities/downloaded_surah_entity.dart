// domain/entities/downloaded_surah_entity.dart
class DownloadedSurahEntity {
  final int reciterId;
  final int surahId;
  final String localPath;
  final bool isDownloaded;


  DownloadedSurahEntity({
    required this.reciterId,
    required this.surahId,
    required this.localPath,
    this.isDownloaded = true,
  });
}