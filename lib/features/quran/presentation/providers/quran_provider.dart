import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/quran_local_datasource.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../domain/entities/surah.dart';
import '../../domain/usecases/get_surah_list.dart';

final quranLocalDataSourceProvider = Provider<QuranLocalDataSource>((ref) {
  return QuranLocalDataSourceImpl();
});

final quranRepositoryProvider = Provider((ref) {
  return QuranRepositoryImpl(ref.read(quranLocalDataSourceProvider));
});

final getSurahsUsecaseProvider = Provider((ref) {
  return GetSurahs(ref.read(quranRepositoryProvider));
});

final surahsProvider = FutureProvider<List<Sura>>((ref) async {
  return ref.read(getSurahsUsecaseProvider)();
});

final quranSearchProvider = StateProvider<String>((ref) => '');

final suraVersesProvider = FutureProvider.family<List<String>, int>((ref, suraId) async {
  final fileName = '$suraId.txt';
  final content = await rootBundle.loadString('assets/files/quran/$fileName');
  return content.split('\n');
});

final recentSurasProvider =
StateNotifierProvider<RecentSurasNotifier, List<List<String>>>((ref) {
  return RecentSurasNotifier();
});

class RecentSurasNotifier extends StateNotifier<List<List<String>>> {
  RecentSurasNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList('recentSuras') ?? [];
    final decoded = encodedList
        .map((e) => List<String>.from(jsonDecode(e)))
        .where((e) => e.length == 3)
        .toList();
    state = decoded;
  }

  Future<void> addRecent(Sura sura) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList('recentSuras') ?? [];
    final List<List<String>> recent = encodedList.map((e) => List<String>.from(jsonDecode(e))).toList();

    recent.removeWhere((item) => item[0] == sura.englishName);

    recent.insert(0, [sura.englishName, sura.arabicName, sura.verses.toString()]);

    final List<List<String>> trimmed = recent.length > 10 ? recent.sublist(0, 10) : recent;

    await prefs.setStringList('recentSuras', trimmed.map((e) => jsonEncode(e)).toList());
    state = trimmed;
  }
}
