// data/repositories/download_repository_impl.dart
import 'dart:io';
import '../../domain/repositories/download_repository.dart';
import '../../domain/entities/downloaded_surah_entity.dart';
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
    // compute local path
    final localPath = await local.getLocalPath(reciterId, surahId);

    // perform download
    await remote.downloadToFile(remoteUrl, localPath, onProgress);

    // ensure file exists
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

    // get from Hive / local db
    final entity = await local.getDownloadedSurah(key);
    if (entity == null) return null;

    final file = File(entity.localPath);

    // check if file still exists on disk
    if (await file.exists()) {
      return file;
    } else {
      // cleanup if Hive says it's downloaded but file is missing
      // await local.removeDownloadedSurah(key);
      return null;
    }
  }
}
