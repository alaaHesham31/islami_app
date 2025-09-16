// import 'package:hive/hive.dart';
//
// part 'RadioResponseModel.g.dart';
//
// @HiveType(typeId: 2)
// class RadiosModel {
//   @HiveField(0)
//   num? id;
//
//   @HiveField(1)
//   String? name;
//
//   @HiveField(2)
//   String? url;
//
//   @HiveField(3)
//   String? recentDate;
//
//   RadiosModel({
//     this.id,
//     this.name,
//     this.url,
//     this.recentDate,
//   });
//
//   factory RadiosModel.fromJson(Map<String, dynamic> json) {
//     return RadiosModel(
//       id: json['id'],
//       name: json['name'],
//       url: json['url'],
//       recentDate: json['recent_date'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'url': url,
//       'recent_date': recentDate,
//     };
//   }
// }
//
// class RadioResponseModel {
//   List<RadiosModel>? radios;
//
//   RadioResponseModel({this.radios});
//
//   factory RadioResponseModel.fromJson(Map<String, dynamic> json) {
//     final list = (json['radios'] as List<dynamic>? ?? []);
//     return RadioResponseModel(
//       radios: list.map((v) => RadiosModel.fromJson(v)).toList(),
//     );
//   }
// }
