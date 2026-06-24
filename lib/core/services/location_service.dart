import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationResult {
  final LatLng? position;
  final bool fromCache;
  final String status;

  const LocationResult({
    required this.position,
    required this.fromCache,
    required this.status,
  });
}

/// Wraps geolocator + the existing last-known-position cache. Keys are kept
/// identical to the original prototype so previously cached positions stay
/// valid across the redesign.
class LocationService {
  static const _latKey = 'last_lat';
  static const _lngKey = 'last_lng';

  bool preciseAccuracy = true;

  Future<LocationResult> loadCachedPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_latKey);
    final lng = prefs.getDouble(_lngKey);
    if (lat != null && lng != null) {
      return LocationResult(
        position: LatLng(lat, lng),
        fromCache: true,
        status: 'Derniere position connue (cache local)',
      );
    }
    return const LocationResult(
      position: null,
      fromCache: false,
      status: 'Position inconnue',
    );
  }

  Future<LocationResult> getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return const LocationResult(
        position: null,
        fromCache: false,
        status: 'Permission de localisation refusee',
      );
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      return const LocationResult(
        position: null,
        fromCache: false,
        status: 'Le GPS est desactive sur l\'appareil',
      );
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: preciseAccuracy
              ? LocationAccuracy.high
              : LocationAccuracy.reduced,
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_latKey, pos.latitude);
      await prefs.setDouble(_lngKey, pos.longitude);
      return LocationResult(
        position: LatLng(pos.latitude, pos.longitude),
        fromCache: false,
        status: 'Position obtenue en direct (GPS)',
      );
    } catch (e) {
      return LocationResult(
        position: null,
        fromCache: false,
        status: 'Erreur de localisation: $e',
      );
    }
  }
}
