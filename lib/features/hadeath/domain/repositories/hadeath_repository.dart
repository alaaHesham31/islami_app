import '../entities/hadeath.dart';

abstract class HadeathRepository {
  Future<List<Hadeath>> getAllAhadeeth();
}
