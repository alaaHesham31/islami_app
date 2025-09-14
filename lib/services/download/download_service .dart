import 'dart:io';
import 'package:dio/dio.dart';
import 'package:islami_app_demo/services/download/download_progress_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:islami_app_demo/model/DownloadedSurahModel.dart';
import 'package:islami_app_demo/services/hive_helper/hive_helpers.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future<String> _getLocalPath(int reciterId, int surahId) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/quran_downloads/reciter_$reciterId');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return '${folder.path}/surah_$surahId.mp3';
  }

  Future<void> downloadSurah({
    required int reciterId,
    required int surahId,
    required String remoteUrl,
    Function(double progress)? onProgress,
  }) async {
    final localPath = await _getLocalPath(reciterId, surahId);
    final key = '${reciterId}_$surahId';

    // notify start
    DownloadProgressManager.instance.setProgress(key, 0.0);

    try {
      await _dio.download(
        remoteUrl,
        localPath,
        onReceiveProgress: (count, total) {
          double prog = 0.0;
          if (total > 0) prog = count / total;
          // update manager
          DownloadProgressManager.instance.setProgress(key, prog);
          if (onProgress != null) onProgress(prog);
        },
        // optional: set a reasonable timeout
        options: Options(receiveTimeout: Duration(seconds: 60000), sendTimeout:  Duration(seconds: 60000)),
      );

      // ensure file exists
      final file = File(localPath);
      if (!await file.exists()) throw Exception('Download finished but file not found');

      // Save metadata in Hive (only after success)
      final box = await getDownloadsBox();
      final model = DownloadedSurah(
        reciterId: reciterId,
        surahId: surahId,
        localPath: localPath,
        isDownloaded: true,
      );
      await box.put(key, model);

      // finalize progress
      DownloadProgressManager.instance.setProgress(key, 1.0);
    } on DioException catch (dioErr) {
      // network/download error
      DownloadProgressManager.instance.setProgress(key, -1.0); // -1 signals error
      rethrow;
    } catch (e) {
      DownloadProgressManager.instance.setProgress(key, -1.0);
      rethrow;
    } finally {
      // optionally clear progress after some time - not done here
    }
  }

  Future<File?> getLocalFile(int reciterId, int surahId) async {
    final box = await getDownloadsBox();
    final key = '${reciterId}_$surahId';

    if (box.containsKey(key)) {
      final data = box.get(key)!;
      final file = File(data.localPath);
      if (await file.exists()) return file;
    }
    return null;
  }
}
