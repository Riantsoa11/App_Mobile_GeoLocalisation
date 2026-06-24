import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/models/nearby_poi.dart';
import 'package:geo_notif_offline/core/models/place.dart';
import 'package:geo_notif_offline/core/models/weather_info.dart';
import 'package:geo_notif_offline/core/services/offline_cache_service.dart';
import 'package:geo_notif_offline/core/services/open_meteo_service.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';
import 'package:geo_notif_offline/core/widgets/atoms/section_label.dart';
import 'package:geo_notif_offline/core/widgets/molecules/poi_list_item.dart';
import 'package:geo_notif_offline/features/detail/data/wikipedia_service.dart';
import 'package:geo_notif_offline/features/detail/presentation/widgets/atoms/info_chip.dart';
import 'package:geo_notif_offline/features/detail/presentation/widgets/atoms/round_icon_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Place place;
  final LatLng? userPosition;

  const PlaceDetailScreen({super.key, required this.place, this.userPosition});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final _weatherService = OpenMeteoService();
  final _wikipediaService = WikipediaService();
  final _cacheService = OfflineCacheService();

  WeatherInfo? _weather;
  String? _description;
  List<NearbyPoi> _pointsOfInterest = [];
  bool _loading = true;
  bool _bookmarked = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<WeatherInfo?> _fetchWeather() async {
    try {
      return await _weatherService.getWeather(widget.place.lat, widget.place.lng);
    } catch (_) {
      return null;
    }
  }

  Future<List<NearbyPoi>> _fetchNearby() async {
    try {
      return await _wikipediaService.getNearby(widget.place.lat, widget.place.lng);
    } catch (_) {
      return <NearbyPoi>[];
    }
  }

  Future<String?> _fetchDescription() async {
    try {
      return await _wikipediaService.getSummary(widget.place.name);
    } catch (_) {
      return null;
    }
  }

  Future<void> _load() async {
    final weather = await _fetchWeather();
    final description = await _fetchDescription();
    final pointsOfInterest = await _fetchNearby();
    final bookmarked = await _cacheService.isBookmarked(widget.place);

    if (!mounted) return;
    setState(() {
      _weather = weather;
      _description = description;
      _pointsOfInterest = pointsOfInterest;
      _bookmarked = bookmarked;
      _loading = false;
    });
  }

  Future<void> _toggleBookmark() async {
    if (_bookmarked) {
      await _cacheService.removeBookmark(widget.place);
    } else {
      await _cacheService.addBookmark(widget.place);
    }
    if (!mounted) return;
    setState(() => _bookmarked = !_bookmarked);
  }

  Future<void> _openItinerary() async {
    final uri = Uri.parse('geo:${widget.place.lat},${widget.place.lng}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String? get _distanceLabel {
    if (widget.userPosition == null) return null;
    final meters = Geolocator.distanceBetween(
      widget.userPosition!.latitude,
      widget.userPosition!.longitude,
      widget.place.lat,
      widget.place.lng,
    );
    return meters < 1000
        ? '${meters.round()} m'
        : '${(meters / 1000).toStringAsFixed(0)} km';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CupertinoActivityIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundIconButton(
                          icon: CupertinoIcons.back,
                          onTap: () => Navigator.pop(context),
                        ),
                        RoundIconButton(
                          icon: _bookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                          onTap: _toggleBookmark,
                          active: _bookmarked,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 160,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '[ PHOTO DU LIEU ]',
                              style: TextStyle(color: AppColors.textSecondary, letterSpacing: 1),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (widget.place.country != null)
                            SectionLabel(text: widget.place.country!),
                          const SizedBox(height: 6),
                          Text(widget.place.name, style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 6),
                          Text(
                            '${widget.place.lat.toStringAsFixed(4)}° N, ${widget.place.lng.toStringAsFixed(4)}° E',
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              InfoChip(
                                label: 'Fuseau',
                                value: _weather?.gmtLabel ?? '—',
                              ),
                              const SizedBox(width: 10),
                              InfoChip(
                                label: 'Meteo',
                                value: _weather != null ? '${_weather!.tempC.round()}°C' : '—',
                              ),
                              const SizedBox(width: 10),
                              InfoChip(
                                label: 'Distance',
                                value: _distanceLabel ?? '—',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _description ?? 'Aucune description disponible pour ce lieu.',
                            style: const TextStyle(height: 1.5, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 24),
                          const SectionLabel(text: "Points d'interet"),
                          const SizedBox(height: 10),
                          if (_pointsOfInterest.isEmpty)
                            const Text('Aucun point d\'interet trouve a proximite.', style: TextStyle(color: AppColors.textSecondary))
                          else
                            ..._pointsOfInterest.map(
                              (poi) => PoiListItem(poi: poi, dotColor: AppColors.violet),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Row(
                      children: [
                        RoundIconButton(
                          icon: _bookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                          onTap: _toggleBookmark,
                          active: _bookmarked,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CupertinoButton.filled(
                            borderRadius: BorderRadius.circular(999),
                            onPressed: _openItinerary,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.location_north_fill, size: 18),
                                SizedBox(width: 8),
                                Text('Itineraire'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
