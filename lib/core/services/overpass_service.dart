import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geo_notif_offline/core/models/nearby_poi.dart';

/// Real nearby points of interest (amenities/shops/leisure) via the public
/// Overpass API on top of OpenStreetMap data (free, no API key required).
class OverpassService {
  final http.Client _client;

  OverpassService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<NearbyPoi>> getNearbyPois(
    double lat,
    double lng, {
    int radiusMeters = 1500,
    int limit = 20,
  }) async {
    final query =
        '[out:json][timeout:25];'
        '('
        'node(around:$radiusMeters,$lat,$lng)["amenity"]["name"];'
        'node(around:$radiusMeters,$lat,$lng)["shop"]["name"];'
        'node(around:$radiusMeters,$lat,$lng)["leisure"]["name"];'
        ');'
        'out $limit;';

    final response = await _client.post(
      Uri.https('overpass-api.de', '/api/interpreter'),
      body: {'data': query},
    );
    if (response.statusCode != 200) {
      throw Exception('Overpass a repondu ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = (data['elements'] as List?) ?? [];

    return elements
        .map((raw) {
          final item = raw as Map<String, dynamic>;
          final tags = (item['tags'] as Map<String, dynamic>?) ?? {};
          final name = tags['name'] as String?;
          if (name == null) return null;

          final poiLat = (item['lat'] as num).toDouble();
          final poiLng = (item['lon'] as num).toDouble();
          final category =
              tags['amenity'] ?? tags['shop'] ?? tags['leisure'] ?? 'Lieu';

          return NearbyPoi(
            name: name,
            category: category as String,
            lat: poiLat,
            lng: poiLng,
            distanceMeters: Geolocator.distanceBetween(
              lat,
              lng,
              poiLat,
              poiLng,
            ),
            bearingDegrees: Geolocator.bearingBetween(lat, lng, poiLat, poiLng),
          );
        })
        .whereType<NearbyPoi>()
        .toList()
      ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
  }
}
