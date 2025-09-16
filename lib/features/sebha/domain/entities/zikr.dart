class Zikr {
  final String text;
  final int count;

  const Zikr({required this.text, required this.count});

  Zikr copyWith({String? text, int? count}) {
    return Zikr(
      text: text ?? this.text,
      count: count ?? this.count,
    );
  }
}
