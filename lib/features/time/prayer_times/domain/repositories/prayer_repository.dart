abstract class PrayerRepository {
  Future<Map<String, DateTime>> getPrayerTimes(
      double lat,
      double lng, {
        DateTime? date,
        bool forceRefresh = false,
      });
}