import 'package:dio/dio.dart';


class DownloadRemoteDataSource {
  final Dio _dio;
  DownloadRemoteDataSource([Dio? dio]) : _dio = dio ?? Dio();


  Future<void> downloadToFile(
      String remoteUrl,
      String localPath,
      void Function(double progress)? onProgress,
      ) async {
    try {
      await _dio.download(
        remoteUrl,
        localPath,
        onReceiveProgress: (count, total) {
          double prog = 0.0;
          if (total > 0) prog = count / total;
          if (onProgress != null) onProgress(prog);
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 60000),
          sendTimeout: const Duration(seconds: 60000),
        ),
      );
    } on DioException {
      rethrow;
    }
  }
}