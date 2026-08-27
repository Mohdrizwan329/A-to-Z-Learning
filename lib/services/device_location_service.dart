import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// What came back from a location attempt: either a place name, or the
/// reason there isn't one.
class LocationResult {
  const LocationResult.found(String this.place) : error = null;
  const LocationResult.failed(String this.error) : place = null;

  /// "Bhopal, Madhya Pradesh" -- what goes in the profile.
  final String? place;

  /// Why it could not be read, ready to show the user.
  final String? error;

  bool get isFound => place != null;
}

/// Reads where the device actually is, and turns that into a place name.
///
/// The profile stores a name, not coordinates: it is shown to a parent, and
/// a lat/long pair would be both meaningless to them and more than the app
/// needs to keep about a child.
class DeviceLocationService {
  DeviceLocationService._();

  /// Asks permission if it has not been given, then reads the position.
  static Future<LocationResult> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationResult.failed(
          'Location is switched off on this device. Turn it on and try again.',
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        return const LocationResult.failed(
          'Location permission was declined. You can type your city instead.',
        );
      }
      if (permission == LocationPermission.deniedForever) {
        return const LocationResult.failed(
          'Location is blocked for this app in Settings. You can type your '
          'city instead.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          // A city name needs nothing finer, and a coarse fix is quicker and
          // costs less battery.
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 20),
        ),
      );

      final name = await _placeName(position.latitude, position.longitude);
      if (name != null) return LocationResult.found(name);

      // Geocoding is a network call and can come back empty; coordinates are
      // still better than nothing.
      return LocationResult.found(
        '${position.latitude.toStringAsFixed(3)}, '
        '${position.longitude.toStringAsFixed(3)}',
      );
    } catch (e) {
      debugPrint('Could not read the device location: $e');
      return const LocationResult.failed(
        'Could not read your location just now. You can type your city instead.',
      );
    }
  }

  /// "City, State", falling back through whatever the lookup did return.
  static Future<String?> _placeName(double lat, double lon) async {
    try {
      final marks = await placemarkFromCoordinates(lat, lon);
      if (marks.isEmpty) return null;
      final mark = marks.first;

      final city = _firstNonEmpty([
        mark.locality,
        mark.subAdministrativeArea,
        mark.subLocality,
      ]);
      final region = _firstNonEmpty([mark.administrativeArea, mark.country]);

      if (city != null && region != null && city != region) {
        return '$city, $region';
      }
      return city ?? region;
    } catch (e) {
      debugPrint('Could not name that location: $e');
      return null;
    }
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }
}
