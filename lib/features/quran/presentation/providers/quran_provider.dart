// lib/features/quran/presentation/providers/quran_providers.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/quran_local_datasource.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../domain/entities/surah.dart';
import '../../domain/usecases/get_surah_list.dart';

// DataSource provider
final quranLocalDataSourceProvider = Provider<QuranLocalDataSource>((ref) {
  return QuranLocalDataSourceImpl();
});

// Repository provider
final quranRepositoryProvider = Provider((ref) {
  return QuranRepositoryImpl(ref.read(quranLocalDataSourceProvider));
});

// Usecase provider
final getSurahsUsecaseProvider = Provider((ref) {
  return GetSurahs(ref.read(quranRepositoryProvider));
});

// Public: list of surahs loaded from JSON
final surahsProvider = FutureProvider<List<Sura>>((ref) async {
  return ref.read(getSurahsUsecaseProvider)();
});

// Search text (UI transient state)
final quranSearchProvider = StateProvider<String>((ref) => '');

// Provider that returns verses for a given sura id (loads asset file)
final suraVersesProvider = FutureProvider.family<List<String>, int>((ref, suraId) async {
  final fileName = '$suraId.txt';
  final content = await rootBundle.loadString('assets/files/quran/$fileName');
  return content.split('\n');
});

// Recent suras management (SharedPreferences)
// stored form: List<String> where each string is jsonEncode([english, arabic, verses])
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

    // remove duplicate english name entries
    recent.removeWhere((item) => item[0] == sura.englishName);

    // insert at top
    recent.insert(0, [sura.englishName, sura.arabicName, sura.verses.toString()]);

    // trim (keep latest 10)
    final List<List<String>> trimmed = recent.length > 10 ? recent.sublist(0, 10) : recent;

    await prefs.setStringList('recentSuras', trimmed.map((e) => jsonEncode(e)).toList());
    state = trimmed;
  }
}
