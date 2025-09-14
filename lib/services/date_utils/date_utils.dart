String dateKeyFor(DateTime dt) {
  final d = DateTime(dt.year, dt.month, dt.day);
  final y = d.year.toString();
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

Map<String, String> timesToJsonMap(Map<String, DateTime> times) =>
    times.map((k, v) => MapEntry(k, v.toIso8601String()));

Map<String, DateTime> jsonMapToTimes(Map<String, dynamic> json) =>
    json.map((k, v) => MapEntry(k, DateTime.parse(v as String)));
