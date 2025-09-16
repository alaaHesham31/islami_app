import 'package:hive/hive.dart';
import '../../domain/entities/reciter.dart';
import 'moshaf_model.dart';

part 'reciter_model.g.dart';

@HiveType(typeId: 0)
class ReciterModel extends Reciter {
  @HiveField(0)
  final int reciterId;

  @HiveField(1)
  final String reciterName;

  @HiveField(2)
  final List<MoshafModel> moshafModels;

  ReciterModel({
    required this.reciterId,
    required this.reciterName,
    required this.moshafModels,
  }) : super(id: reciterId, name: reciterName, moshaf: moshafModels);

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      reciterId: int.tryParse(json['id'].toString()) ?? 0,
      reciterName: (json['name'] ?? '').toString(),
      moshafModels: (json['moshaf'] as List<dynamic>)
          .map((e) => MoshafModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
