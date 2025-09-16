// lib/features/hadeath/domain/repositories/hadeath_repository.dart
import '../entities/hadeath.dart';

abstract class HadeathRepository {
  Future<List<Hadeath>> getAllAhadeeth();
}
