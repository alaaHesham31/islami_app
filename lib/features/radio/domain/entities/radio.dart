import 'package:hive/hive.dart';

part 'radio.g.dart';

@HiveType(typeId: 2)
class RadioEntity {
  @HiveField(0)
  final num? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? url;

  @HiveField(3)
  final String? recentDate;

  const RadioEntity({
    this.id,
    this.name,
    this.url,
    this.recentDate,
  });
}
