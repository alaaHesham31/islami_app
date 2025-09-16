// domain/usecases/download_surah_usecase.dart
import '../repositories/download_repository.dart';


class DownloadSurahUseCase {
  final DownloadRepository repository;
  DownloadSurahUseCase(this.repository);


  Future<String> call({
    required int reciterId,
    required int surahId,
    required String remoteUrl,
    void Function(double progress)? onProgress,
  }) async {
    return await repository.downloadSurah(
      reciterId: reciterId,
      surahId: surahId,
      remoteUrl: remoteUrl,
      onProgress: onProgress,
    );
  }
}