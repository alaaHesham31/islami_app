import '../entities/reciter.dart';
import '../../domain/entities/surah.dart';

abstract class RecitersRepository {
  Future<List<Reciter>> getAllReciters();
  Future<List<Surah>> getSurahsNames();
}
