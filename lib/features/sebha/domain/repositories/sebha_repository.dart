import '../entities/zikr.dart';

abstract class SebhaRepository {
  List<String> getAzkar();
  Zikr incrementTasbeeh(Zikr current);
}
