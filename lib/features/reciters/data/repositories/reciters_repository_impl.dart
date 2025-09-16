import '../../domain/entities/reciter.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/reciters_repository.dart';
import '../datasources/reciters_local_data_source.dart';
import '../datasources/reciters_remote_data_source.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class RecitersRepositoryImpl implements RecitersRepository {
  final RecitersLocalDataSource localDataSource;
  final RecitersRemoteDataSource remoteDataSource;

  RecitersRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Reciter>> getAllReciters() async {
    final cached = await localDataSource.getCachedReciters();
    if (cached.isNotEmpty) return cached;

    final remote = await remoteDataSource.fetchReciters();
    await localDataSource.cacheReciters(remote);
    return remote;
  }

  @override
  Future<List<Surah>> getSurahsNames() async {
    final jsonString = await rootBundle.loadString('assets/files/surah_names.json');
    final List decoded = jsonDecode(jsonString);
    return decoded.map((sura) {
      return Surah(
        id: sura['id'],
        arabicName: sura['arabic_name'],
        englishName: sura['english_name'],
        verses: sura['verses'],
        type: sura['type'],
      );
    }).toList();
  }
}
