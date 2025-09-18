import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../services/download/download_progress_manager.dart';


import '../../domain/repositories/download_repository.dart';

class DownloadService {
  final DownloadRepository _repository;

  DownloadService({required DownloadRepository repository})
      : _repository = repository;

  Future<void> downloadSurah({
    required int reciterId,
    required int surahId,
    required String remoteUrl,
    Function(double progress)? onProgress,
  }) async {
    final key = '${reciterId}_$surahId';

    DownloadProgressManager.instance.setProgress(key, 0.0);

    try {
      await _repository.downloadSurah(
        reciterId: reciterId,
        surahId: surahId,
        remoteUrl: remoteUrl,
        onProgress: (prog) {
          DownloadProgressManager.instance.setProgress(key, prog);
          if (onProgress != null) onProgress(prog);
        },
      );

      // finalize progress
      DownloadProgressManager.instance.setProgress(key, 1.0);
    } on DioException catch (_) {
      DownloadProgressManager.instance.setProgress(key, -1.0);
      rethrow;
    } catch (_) {
      DownloadProgressManager.instance.setProgress(key, -1.0);
      rethrow;
    }
  }

  /// Returns local File if exists, otherwise null.
  Future<File?> getLocalFile(int reciterId, int surahId) {
    return _repository.getLocalFile(reciterId, surahId);
  }
}
