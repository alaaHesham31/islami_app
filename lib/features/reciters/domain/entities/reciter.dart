import 'package:equatable/equatable.dart';
import 'moshaf.dart';

class Reciter extends Equatable {
  final int id;
  final String name;
  final List<Moshaf> moshaf;

  const Reciter({
    required this.id,
    required this.name,
    required this.moshaf,
  });

  @override
  List<Object?> get props => [id, name, moshaf];
}
