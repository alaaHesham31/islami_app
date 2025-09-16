
import '../entities/surah.dart';

abstract class QuranRepository {
  Future<List<Sura>> getSurahs();
}
