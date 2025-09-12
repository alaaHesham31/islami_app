class ReciterModel {
  final int id;
  final String name;
  final List<MoshafModel> moshaf;

  ReciterModel({required this.id, required this.name, required this.moshaf});

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['id'],
      name: json['name'],
      moshaf: (json['moshaf'] as List)
          .map((e) => MoshafModel.fromJson(e))
          .toList(),
    );
  }
}

class MoshafModel {
  final int id;
  final String name;
  final String server;
  final String surahList;

  MoshafModel({required this.id, required this.name, required this.server, required this.surahList});

  factory MoshafModel.fromJson(Map<String, dynamic> json) {
    return MoshafModel(
      id: json['id'],
      name: json['name'],
      server: json['server'],
      surahList: json['surah_list'],
    );
  }
}
