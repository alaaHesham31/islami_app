import 'package:equatable/equatable.dart';

class Moshaf extends Equatable {
  final int id;
  final String name;
  final String server;
  final String surahList;

  const Moshaf({
    required this.id,
    required this.name,
    required this.server,
    required this.surahList,
  });

  @override
  List<Object?> get props => [id, name, server, surahList];
}
