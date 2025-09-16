import '../../domain/entities/surah.dart';

class SuraModel extends Sura {
  SuraModel({
    required int id,
    required String arabicName,
    required String englishName,
    required int verses,
    required String type,
  }) : super(
    id: id,
    arabicName: arabicName,
    englishName: englishName,
    verses: verses,
    type: type,
  );

  factory SuraModel.fromJson(Map<String, dynamic> json) {
    final dynamic idRaw = json['id'];
    final dynamic versesRaw = json['verses'];
    final int id = (idRaw is int) ? idRaw : int.tryParse('$idRaw') ?? 0;
    final int verses = (versesRaw is int) ? versesRaw : int.tryParse('$versesRaw') ?? 0;

    return SuraModel(
      id: id,
      arabicName: json['arabic_name']?.toString() ?? '',
      englishName: json['english_name']?.toString() ?? '',
      verses: verses,
      type: json['type']?.toString() ?? '',
    );
  }
}
