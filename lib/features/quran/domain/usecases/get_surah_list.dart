
import '../entities/surah.dart';
import '../repositories/quran_repository.dart';

class GetSurahs {
  final QuranRepository repository;
  GetSurahs(this.repository);

  Future<List<Sura>> call() async {
    return await repository.getSurahs();
  }
}
