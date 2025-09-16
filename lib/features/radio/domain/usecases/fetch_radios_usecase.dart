import '../entities/radio.dart';
import '../repositories/radio_repository.dart';

class FetchRadiosUseCase {
  final RadioRepository repository;

  FetchRadiosUseCase(this.repository);

  Future<List<RadioEntity>> call() async {
    return await repository.fetchRadios();
  }
}
