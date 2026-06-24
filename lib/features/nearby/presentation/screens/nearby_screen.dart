import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/models/nearby_poi.dart';
import 'package:geo_notif_offline/core/services/location_service.dart';
import 'package:geo_notif_offline/core/services/nominatim_service.dart';
import 'package:geo_notif_offline/core/services/overpass_service.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';
import 'package:geo_notif_offline/core/widgets/atoms/section_label.dart';
import 'package:geo_notif_offline/core/widgets/molecules/poi_list_item.dart';
import 'package:geo_notif_offline/features/nearby/presentation/widgets/organisms/radar_painter.dart';
import 'package:latlong2/latlong.dart';

class NearbyScreen extends StatefulWidget {
  final LatLng? position;
  final LocationService locationService;
  final ValueChanged<LatLng> onPositionUpdated;

  const NearbyScreen({
    super.key,
    required this.position,
    required this.locationService,
    required this.onPositionUpdated,
  });

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  final _overpass = OverpassService();
  final _nominatim = NominatimService();

  List<NearbyPoi> _pois = [];
  String? _areaLabel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(NearbyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) _load();
  }

  Future<void> _load() async {
    final position = widget.position;
    if (position == null) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _overpass.getNearbyPois(
          position.latitude,
          position.longitude,
          radiusMeters: kRadarRadiusMeters.round(),
        ),
        _nominatim.reverse(position.latitude, position.longitude),
      ]);
      if (!mounted) return;
      setState(() {
        _pois = results[0] as List<NearbyPoi>;
        _areaLabel = results[1] as String?;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _recenter() async {
    final result = await widget.locationService.getCurrentLocation();
    if (result.position != null) widget.onPositionUpdated(result.position!);
  }

  Future<void> _togglePrecision(bool value) async {
    widget.locationService.preciseAccuracy = value;
    setState(() {});
    await _recenter();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Autour de moi', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    if (_areaLabel != null)
                      Row(
                        children: [
                          const Icon(CupertinoIcons.location, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(_areaLabel!, style: const TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                  ],
                ),
                IconButton.filled(
                  onPressed: _recenter,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  icon: const Icon(CupertinoIcons.location_fill),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.position == null)
              _EmptyState(onRetry: _recenter)
            else ...[
              AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: RadarPainter(pois: _pois),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'RAYON ${(kRadarRadiusMeters / 1000).toStringAsFixed(1)} KM · ${_pois.length} LIEUX',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: kCardShadow,
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.compass, size: 18, color: AppColors.accentDark),
                    const SizedBox(width: 10),
                    const Expanded(child: Text('Localisation precise', style: TextStyle(fontWeight: FontWeight.w600))),
                    CupertinoSwitch(
                      value: widget.locationService.preciseAccuracy,
                      onChanged: _togglePrecision,
                      activeTrackColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SectionLabel(text: 'A proximite'),
              const SizedBox(height: 10),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CupertinoActivityIndicator()),
                )
              else if (_pois.isEmpty)
                const Text('Aucun lieu trouve a proximite.', style: TextStyle(color: AppColors.textSecondary))
              else
                ...List.generate(
                  _pois.length,
                  (i) => PoiListItem(poi: _pois[i], dotColor: kPoiColors[i % kPoiColors.length]),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text('Position inconnue.', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          CupertinoButton.filled(
            borderRadius: BorderRadius.circular(999),
            onPressed: onRetry,
            child: const Text('Activer la localisation'),
          ),
        ],
      ),
    );
  }
}
