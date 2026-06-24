import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geo_notif_offline/core/models/weather_info.dart';

/// Current weather + timezone via Open-Meteo (free, no API key required).
class OpenMeteoService {
  final http.Client _client;

  OpenMeteoService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherInfo> getWeather(double lat, double lng) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': lat.toString(),
      'longitude': lng.toString(),
      'current_weather': 'true',
      'timezone': 'auto',
    });

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Open-Meteo a repondu ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final current = data['current_weather'] as Map<String, dynamic>;
    return WeatherInfo(
      tempC: (current['temperature'] as num).toDouble(),
      weatherCode: (current['weathercode'] as num).toInt(),
      timezone: data['timezone'] as String,
      utcOffsetSeconds: data['utc_offset_seconds'] as int,
    );
  }
}
