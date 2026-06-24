import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/models/place.dart';
import 'package:geo_notif_offline/core/services/nominatim_service.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';
import 'package:geo_notif_offline/core/widgets/atoms/section_label.dart';
import 'package:geo_notif_offline/features/explorer/data/seed_places.dart';
import 'package:geo_notif_offline/features/explorer/presentation/widgets/molecules/offline_banner.dart';
import 'package:geo_notif_offline/features/explorer/presentation/widgets/molecules/pill_search_bar.dart';
import 'package:geo_notif_offline/features/explorer/presentation/widgets/organisms/real_earth_globe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

const _pinColors = [
  AppColors.accent,
  AppColors.pink,
  AppColors.violet,
  AppColors.warning,
];

class ExplorerScreen extends StatefulWidget {
  final LatLng? position;
  final bool isOnline;
  final int savedPlacesCount;
  final ValueChanged<Place> onOpenDetail;
  final VoidCallback onOpenProfile;

  const ExplorerScreen({
    super.key,
    required this.position,
    required this.isOnline,
    required this.savedPlacesCount,
    required this.onOpenDetail,
    required this.onOpenProfile,
  });

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  final _nominatim = NominatimService();
  final _searchController = TextEditingController();
  bool _showGlobeHint = true;
  bool _searching = false;

  late final Place _featuredPlace =
      kFeaturedPlaces[DateTime.now().day % kFeaturedPlaces.length];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _showGlobeHint = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _searching = true);
    try {
      final results = await _nominatim.search(query);
      if (!mounted) return;
      setState(() => _searching = false);
      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun lieu trouve.')),
        );
        return;
      }
      _showResultsSheet(results);
    } catch (e) {
      if (!mounted) return;
      setState(() => _searching = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recherche impossible : $e')),
      );
    }
  }

  void _showResultsSheet(List<Place> results) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final place = results[index];
              return ListTile(
                leading: const Icon(CupertinoIcons.location_solid, color: AppColors.accentDark),
                title: Text(place.name),
                subtitle: place.country != null ? Text(place.country!) : null,
                onTap: () {
                  Navigator.pop(context);
                  widget.onOpenDetail(place);
                },
              );
            },
          ),
        );
      },
    );
  }

  double? get _featuredDistanceKm {
    if (widget.position == null) return null;
    return Geolocator.distanceBetween(
          widget.position!.latitude,
          widget.position!.longitude,
          _featuredPlace.lat,
          _featuredPlace.lng,
        ) /
        1000;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel(text: 'Orbe', icon: CupertinoIcons.sparkles),
                      const SizedBox(height: 4),
                      Text('Explorer', style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
                IconButton.filled(
                  onPressed: widget.onOpenProfile,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  icon: const Icon(CupertinoIcons.person),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PillSearchBar(
              hint: 'Rechercher un lieu, une ville...',
              controller: _searchController,
              onSubmitted: _runSearch,
            ),
            if (_searching) const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(child: CupertinoActivityIndicator()),
            ),
            const SizedBox(height: 14),
            OfflineBanner(
              isOnline: widget.isOnline,
              savedPlacesCount: widget.savedPlacesCount,
            ),
            const SizedBox(height: 28),
            AspectRatio(
              aspectRatio: 1,
              child: RealEarthGlobe(
                featuredPlaces: kFeaturedPlaces,
                featuredColors: _pinColors,
                onPlaceTap: widget.onOpenDetail,
              ),
            ),
            AnimatedOpacity(
              opacity: _showGlobeHint ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: SectionLabel(text: 'Glisser pour tourner', icon: CupertinoIcons.rotate_left),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => widget.onOpenDetail(_featuredPlace),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: kCardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(CupertinoIcons.photo, color: AppColors.accentDark),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionLabel(text: 'A la une', icon: CupertinoIcons.star),
                          const SizedBox(height: 4),
                          Text(
                            _featuredPlace.name,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          Text(
                            '${_featuredPlace.lat.toStringAsFixed(2)}° N, ${_featuredPlace.lng.toStringAsFixed(2)}° E',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (_featuredDistanceKm != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${_featuredDistanceKm!.toStringAsFixed(0)} km',
                          style: const TextStyle(color: AppColors.accentDark, fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                    const SizedBox(width: 6),
                    const Icon(CupertinoIcons.chevron_right, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
