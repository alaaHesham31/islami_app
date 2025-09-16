import 'package:hive/hive.dart';
import '../../domain/entities/moshaf.dart';

part 'moshaf_model.g.dart';

@HiveType(typeId: 1)
class MoshafModel extends Moshaf {
  @HiveField(0)
  final int moshafId;

  @HiveField(1)
  final String moshafName;

  @HiveField(2)
  final String serverUrl;

  @HiveField(3)
  final String surahList;

  MoshafModel({
    required this.moshafId,
    required this.moshafName,
    required this.serverUrl,
    required this.surahList,
  }) : super(id: moshafId, name: moshafName, server: serverUrl, surahList: surahList);

  factory MoshafModel.fromJson(Map<String, dynamic> json) {
    return MoshafModel(
      moshafId: int.tryParse(json['id'].toString()) ?? 0,
      moshafName: json['name'] ?? '',
      serverUrl: json['server'] ?? '',
      surahList: json['surah_list'] ?? '',
    );
  }
}
