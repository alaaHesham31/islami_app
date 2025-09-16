// lib/features/download/data/datasources/download_local_datasource.dart
import 'dart:io';
import 'package:islami_app_demo/features/download/data/models/DownloadedSurahModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

const String downloadsBoxName = 'downloadsBox'; // KEEP the existing name used across your app

/// Concrete local datasource used by the repository.
/// - Provides local path creation
/// - CRUD for Hive saved downloads
class DownloadLocalDataSource {
  DownloadLocalDataSource();

  Future<String> getLocalPath(int reciterId, int surahId) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/quran_downloads/reciter_$reciterId');
    if (!await folder.exists()) await folder.create(recursive: true);
    return '${folder.path}/surah_$surahId.mp3';
  }

  Future<Box<DownloadedSurahModel>> _getBox() async {
    if (!Hive.isBoxOpen(downloadsBoxName)) {
      return await Hive.openBox<DownloadedSurahModel>(downloadsBoxName);
    }
    return Hive.box<DownloadedSurahModel>(downloadsBoxName);
  }

  Future<void> saveDownloadedSurah(DownloadedSurahModel model, String key) async {
    final box = await _getBox();
    await box.put(key, model);
  }

  Future<DownloadedSurahModel?> getDownloadedSurah(String key) async {
    final box = await _getBox();
    return box.containsKey(key) ? box.get(key) : null;
  }

  Future<Map<String, DownloadedSurahModel>> getAllDownloadedSurahs() async {
    final box = await _getBox();
    // Ensure keys are strings
    final Map<String, DownloadedSurahModel> out = {};
    for (final e in box.toMap().entries) {
      out[e.key.toString()] = e.value as DownloadedSurahModel;
    }
    return out;
  }

  Future<void> deleteDownloadedSurah(String key) async {
    final box = await _getBox();
    if (box.containsKey(key)) await box.delete(key);
  }
}
