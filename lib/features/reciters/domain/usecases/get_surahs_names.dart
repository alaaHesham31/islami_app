import '../entities/surah.dart';
import '../repositories/reciters_repository.dart';

class GetSurahsNames {
  final RecitersRepository repository;

  GetSurahsNames(this.repository);

  Future<List<Surah>> call() async {
    return await repository.getSurahsNames();
  }
}
