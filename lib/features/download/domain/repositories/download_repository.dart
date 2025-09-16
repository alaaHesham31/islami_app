// domain/repositories/download_repository.dart
import 'dart:io';
import '../entities/downloaded_surah_entity.dart';


abstract class DownloadRepository {
  /// Download surah to local path and persist metadata.
  /// Returns the local file path on success.
  Future<String> downloadSurah({
    required int reciterId,
    required int surahId,
    required String remoteUrl,
    void Function(double progress)? onProgress,
  });


  /// Return local File if exists, otherwise null.
  Future<File?> getLocalFile(int reciterId, int surahId);
}