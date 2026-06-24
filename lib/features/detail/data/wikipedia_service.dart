import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geo_notif_offline/core/models/nearby_poi.dart';

/// Place descriptions + nearby points of interest via the public
/// Wikipedia REST/MediaWiki APIs (free, no API key required).
class WikipediaService {
  final http.Client _client;

  WikipediaService({http.Client? client}) : _client = client ?? http.Client();

  Future<String?> getSummary(String title) async {
    final uri = Uri.https(
      'fr.wikipedia.org',
      '/api/rest_v1/page/summary/${Uri.encodeComponent(title)}',
    );
    final response = await _client.get(uri);
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final extract = data['extract'] as String?;
    return (extract == null || extract.isEmpty) ? null : extract;
  }

  Future<List<NearbyPoi>> getNearby(
    double lat,
    double lng, {
    int radiusMeters = 10000,
  }) async {
    final uri = Uri.https('fr.wikipedia.org', '/w/api.php', {
      'action': 'query',
      'list': 'geosearch',
      'gscoord': '$lat|$lng',
      'gsradius': radiusMeters.toString(),
      'gslimit': '10',
      'format': 'json',
    });

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Wikipedia a repondu ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (data['query']?['geosearch'] as List?) ?? [];
    return results.map((raw) {
      final item = raw as Map<String, dynamic>;
      final poiLat = (item['lat'] as num).toDouble();
      final poiLng = (item['lon'] as num).toDouble();
      return NearbyPoi(
        name: item['title'] as String,
        category: "Point d'interet",
        lat: poiLat,
        lng: poiLng,
        distanceMeters: (item['dist'] as num).toDouble(),
        bearingDegrees: Geolocator.bearingBetween(lat, lng, poiLat, poiLng),
      );
    }).toList();
  }
}
