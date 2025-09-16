
import 'package:islami_app_demo/features/quran/data/models/surah_model.dart';

import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_datasource.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource localDataSource;

  QuranRepositoryImpl(this.localDataSource);

  @override
  Future<List<Sura>> getSurahs() async {
    final List<SuraModel> models = await localDataSource.loadSurahs();

    return models
        .map<Sura>((m) => Sura(
      id: m.id,
      arabicName: m.arabicName,
      englishName: m.englishName,
      verses: m.verses,
      type: m.type,
    ))
        .toList();
  }
}
