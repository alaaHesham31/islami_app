import '../entities/reciter.dart';
import '../repositories/reciters_repository.dart';

class GetAllReciters {
  final RecitersRepository repository;

  GetAllReciters(this.repository);

  Future<List<Reciter>> call() async {
    return await repository.getAllReciters();
  }
}
