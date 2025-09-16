import '../entities/zikr.dart';
import '../repositories/sebha_repository.dart';

class IncrementTasbeehUseCase {
  final SebhaRepository repository;

  IncrementTasbeehUseCase(this.repository);

  Zikr call(Zikr current) {
    return repository.incrementTasbeeh(current);
  }
}
