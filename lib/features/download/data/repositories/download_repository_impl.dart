import 'dart:io';
import '../../domain/repositories/download_repository.dart';
import '../datasources/download_local_datasource.dart';
import '../datasources/download_remote_datasource.dart';
import '../models/DownloadedSurahModel.dart';

class DownloadRepositoryImpl implements DownloadRepository {
  final DownloadLocalDataSource local;
  final DownloadRemoteDataSource remote;

  DownloadRepositoryImpl({required this.local, required this.remote});

  @override
  Future<String> downloadSurah({
    required int reciterId,
    required int surahId,
    required String remoteUrl,
    void Function(double progress)? onProgress,
  }) async {
    final key = '${reciterId}_$surahId';
    final localPath = await local.getLocalPath(reciterId, surahId);

    await remote.downloadToFile(remoteUrl, localPath, onProgress);

    final file = File(localPath);
    if (!await file.exists())
      throw Exception('Download finished but file not found');

    // persist metadata
    final model = DownloadedSurahModel(
      reciterId: reciterId,
      surahId: surahId,
      localPath: localPath,
      isDownloaded: true,
    );

    await local.saveDownloadedSurah(model, key);

    return localPath;
  }

  @override
  Future<File?> getLocalFile(int reciterId, int surahId) async {
    final key = '${reciterId}_$surahId';

    final entity = await local.getDownloadedSurah(key);
    if (entity == null) return null;

    final file = File(entity.localPath);

    if (await file.exists()) {
      return file;
    } else {

      return null;
    }
  }
}
