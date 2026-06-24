import 'package:geo_notif_offline/core/services/offline_cache_service.dart';
import 'package:geo_notif_offline/core/services/open_meteo_service.dart';
import 'package:geo_notif_offline/core/services/overpass_service.dart';
import 'package:latlong2/latlong.dart';
import 'alert_item.dart';

/// Builds the Alertes list from real signals only: nearby real POIs,
/// places the user actually saved for offline use, and real weather risk
/// for saved places (or the current position). Computed on demand
/// (screen load / pull-to-refresh) — no background workers.
class AlertsService {
  final OverpassService _overpass;
  final OfflineCacheService _cache;
  final OpenMeteoService _weather;

  AlertsService({
    OverpassService? overpass,
    OfflineCacheService? cache,
    OpenMeteoService? weather,
  }) : _overpass = overpass ?? OverpassService(),
       _cache = cache ?? OfflineCacheService(),
       _weather = weather ?? OpenMeteoService();

  Future<List<AlertItem>> build(LatLng? currentPosition) async {
    final alerts = <AlertItem>[];
    final now = DateTime.now();

    if (currentPosition != null) {
      try {
        final pois = await _overpass.getNearbyPois(
          currentPosition.latitude,
          currentPosition.longitude,
          radiusMeters: 150,
          limit: 3,
        );
        for (final poi in pois) {
          alerts.add(
            AlertItem(
              type: AlertType.proximity,
              title: 'A ${poi.distanceLabel} de vous',
              message: '${poi.name} (${poi.category}) est tout proche.',
              time: now,
            ),
          );
        }
      } catch (_) {
        // Proximity is best-effort: no network shouldn't break the screen.
      }
    }

    final bookmarks = await _cache.getBookmarks();
    final recentBookmarks = bookmarks.where(
      (b) => now.difference(b.savedAt).inDays < 7,
    );
    for (final bookmark in recentBookmarks) {
      alerts.add(
        AlertItem(
          type: AlertType.saved,
          title: 'Nouveau lieu ajoute',
          message: '${bookmark.place.name} est disponible hors-ligne.',
          time: bookmark.savedAt,
        ),
      );

      try {
        final weather = await _weather.getWeather(
          bookmark.place.lat,
          bookmark.place.lng,
        );
        if (weather.isRisky) {
          alerts.add(
            AlertItem(
              type: AlertType.weatherRisk,
              title: 'Alerte meteo',
              message:
                  'Conditions meteo difficiles prevues a ${bookmark.place.name}.',
              time: now,
            ),
          );
        }
      } catch (_) {
        // Weather is best-effort: no network shouldn't break the screen.
      }
    }

    alerts.sort((a, b) => b.time.compareTo(a.time));
    return alerts;
  }
}
