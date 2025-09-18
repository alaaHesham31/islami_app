import 'dart:io';


abstract class DownloadRepository {

  Future<String> downloadSurah({
    required int reciterId,
    required int surahId,
    required String remoteUrl,
    void Function(double progress)? onProgress,
  });


  Future<File?> getLocalFile(int reciterId, int surahId);
}