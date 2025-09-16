// domain/usecases/get_local_file_usecase.dart
import 'dart:io';
import '../repositories/download_repository.dart';


class GetLocalFileUseCase {
  final DownloadRepository repository;
  GetLocalFileUseCase(this.repository);


  Future<File?> call(int reciterId, int surahId) async {
    return await repository.getLocalFile(reciterId, surahId);
  }
}