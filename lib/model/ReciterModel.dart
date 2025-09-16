// import 'package:hive/hive.dart';
//
// part 'ReciterModel.g.dart';
//
// @HiveType(typeId: 0)
// class ReciterModel {
//   @HiveField(0)
//   final int id;
//
//   @HiveField(1)
//   final String name;
//
//   @HiveField(2)
//   final List<MoshafModel> moshaf;
//
//   ReciterModel({
//     required this.id,
//     required this.name,
//     required this.moshaf,
//   });
//
//   factory ReciterModel.fromJson(Map<String, dynamic> json) {
//     final rawId = json['id'];
//     final int id = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0;
//
//     final name = (json['name'] ?? '').toString();
//
//     final rawMoshaf = json['moshaf'];
//     final List<MoshafModel> moshaf = (rawMoshaf is List)
//         ? rawMoshaf
//             .map((e) => MoshafModel.fromJson(Map<String, dynamic>.from(e)))
//             .toList()
//         : <MoshafModel>[];
//
//     return ReciterModel(id: id, name: name, moshaf: moshaf);
//   }
// }
//
// @HiveType(typeId: 1)
// class MoshafModel {
//   @HiveField(0)
//   final int id;
//
//   @HiveField(1)
//   final String name;
//
//   @HiveField(2)
//   final String server;
//
//   @HiveField(3)
//   final String surahList;
//
//   MoshafModel({
//     required this.id,
//     required this.name,
//     required this.server,
//     required this.surahList,
//   });
//
//   factory MoshafModel.fromJson(Map<String, dynamic> json) {
//     final rawId = json['id'];
//     final int id = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0;
//
//     final name = (json['name'] ?? '').toString();
//     final server = (json['server'] ?? '').toString();
//     final surahList = (json['surah_list'] ?? json['surahList'] ?? '').toString();
//
//     return MoshafModel(
//       id: id,
//       name: name,
//       server: server,
//       surahList: surahList,
//     );
//   }
// }
