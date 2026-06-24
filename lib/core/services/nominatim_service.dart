import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geo_notif_offline/core/models/place.dart';

/// Free-text place/city search via OpenStreetMap's Nominatim.
/// Usage policy requires a descriptive User-Agent and a reasonable request rate.
class NominatimService {
  static const _userAgent = 'geo_notif_offline Flutter app (Ynov project)';

  final http.Client _client;

  NominatimService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Place>> search(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'jsonv2',
      'limit': '8',
      'addressdetails': '1',
    });

    final response = await _client.get(
      uri,
      headers: {'User-Agent': _userAgent},
    );
    if (response.statusCode != 200) {
      throw Exception('Nominatim a repondu ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as List;
    return data.map((raw) {
      final item = raw as Map<String, dynamic>;
      final address = item['address'] as Map<String, dynamic>?;
      return Place(
        name: (item['name'] as String?)?.isNotEmpty == true
            ? item['name'] as String
            : (item['display_name'] as String).split(',').first,
        lat: double.parse(item['lat'] as String),
        lng: double.parse(item['lon'] as String),
        country: address?['country'] as String?,
        region: (address?['state'] ?? address?['region']) as String?,
      );
    }).toList();
  }

  /// Reverse geocoding: turns coordinates into a human-readable place label
  /// (e.g. "Paris 1er, France"), used to show the user's approximate area.
  Future<String?> reverse(double lat, double lng) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'lat': lat.toString(),
      'lon': lng.toString(),
      'format': 'jsonv2',
    });

    final response = await _client.get(
      uri,
      headers: {'User-Agent': _userAgent},
    );
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final address = data['address'] as Map<String, dynamic>?;
    if (address == null) return null;

    final locality =
        address['suburb'] ?? address['city_district'] ?? address['city'] ?? address['town'] ?? address['village'];
    final country = address['country'];
    if (locality == null && country == null) return null;
    return [locality, country].whereType<String>().join(', ');
  }
}
