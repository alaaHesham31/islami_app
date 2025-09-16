import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:islami_app_demo/features/quran/data/models/surah_model.dart';

abstract class QuranLocalDataSource {
  Future<List<SuraModel>> loadSurahs();
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  @override
  Future<List<SuraModel>> loadSurahs() async {
    final String jsonString = await rootBundle.loadString('assets/files/surah_names.json');
    final List decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((e) => SuraModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
