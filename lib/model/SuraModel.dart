class SuraModel {
  SuraModel({
      this.id, 
      this.arabicName, 
      this.englishName, 
      this.verses, 
      this.type,});

  SuraModel.fromJson(dynamic json) {
    id = json['id'];
    arabicName = json['arabic_name'];
    englishName = json['english_name'];
    verses = json['verses'];
    type = json['type'];
  }
  num? id;
  String? arabicName;
  String? englishName;
  num? verses;
  String? type;


}