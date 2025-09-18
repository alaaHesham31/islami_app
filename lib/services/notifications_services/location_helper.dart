import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

class LocationService {
  static const _box = 'prayer_cache';
  static const _latKey = 'last_lat';
  static const _lngKey = 'last_lng';

  /// Get current location (requests permission). Also saves the result to Hive.
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services are disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permanently denied");
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Save last-known location for background scheduling
    try {
      final box = await Hive.openBox(_box);
      await box.put(_latKey, pos.latitude);
      await box.put(_lngKey, pos.longitude);
      if (kDebugMode)
        debugPrint(
          '💾 Saved last location to Hive: ${pos.latitude},${pos.longitude}',
        );
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Failed to save last location to Hive: $e');
    }

    return pos;
  }

  /// Returns saved location from Hive if present (no permission prompt).
  static Future<Position?> getSavedLocation() async {
    try {
      final box = await Hive.openBox(_box);
      final lat = box.get(_latKey) as double?;
      final lng = box.get(_lngKey) as double?;
      if (lat == null || lng == null) return null;
      return Position(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0, headingAccuracy: 0.0,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ getSavedLocation error: $e');
      return null;
    }
  }
}
