import '../entities/radio.dart';

abstract class RadioRepository {
  Future<List<RadioEntity>> fetchRadios();
}
