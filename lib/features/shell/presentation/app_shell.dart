import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/models/place.dart';
import 'package:geo_notif_offline/core/services/connectivity_service.dart';
import 'package:geo_notif_offline/core/services/location_service.dart';
import 'package:geo_notif_offline/core/services/notification_service.dart';
import 'package:geo_notif_offline/core/services/offline_cache_service.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';
import 'package:geo_notif_offline/core/widgets/organisms/app_bottom_nav.dart';
import 'package:geo_notif_offline/features/alerts/presentation/screens/alerts_screen.dart';
import 'package:geo_notif_offline/features/detail/presentation/screens/place_detail_screen.dart';
import 'package:geo_notif_offline/features/explorer/presentation/screens/explorer_screen.dart';
import 'package:geo_notif_offline/features/nearby/presentation/screens/nearby_screen.dart';
import 'package:geo_notif_offline/features/profile/presentation/screens/profile_screen.dart';
import 'package:latlong2/latlong.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _locationService = LocationService();
  final _connectivityService = ConnectivityService();
  final _notificationService = NotificationService();
  final _cacheService = OfflineCacheService();

  int _currentIndex = 0;
  LatLng? _position;
  bool _isOnline = true;
  int _savedPlacesCount = 0;

  @override
  void initState() {
    super.initState();
    _bootstrap();
    _connectivityService.onChange.listen((isOnline) {
      if (mounted) setState(() => _isOnline = isOnline);
    });
  }

  /// Android only allows one runtime-permission prompt at a time, so the
  /// notification and location requests must be sequenced rather than fired
  /// concurrently (otherwise the second prompt gets silently cancelled).
  Future<void> _bootstrap() async {
    await _notificationService.init();
    await _bootstrapLocation();
    await _bootstrapConnectivity();
    await _refreshSavedPlacesCount();
  }

  Future<void> _bootstrapLocation() async {
    final cached = await _locationService.loadCachedPosition();
    if (cached.position != null && mounted) {
      setState(() => _position = cached.position);
    }
    final live = await _locationService.getCurrentLocation();
    if (live.position != null && mounted) {
      setState(() => _position = live.position);
    }
  }

  Future<void> _bootstrapConnectivity() async {
    final isOnline = await _connectivityService.checkIsOnline();
    if (mounted) setState(() => _isOnline = isOnline);
  }

  Future<void> _refreshSavedPlacesCount() async {
    final bookmarks = await _cacheService.getBookmarks();
    if (mounted) setState(() => _savedPlacesCount = bookmarks.length);
  }

  void _openDetail(Place place) {
    Navigator.of(context)
        .push(
          CupertinoPageRoute(
            builder: (_) => PlaceDetailScreen(place: place, userPosition: _position),
          ),
        )
        .then((_) => _refreshSavedPlacesCount());
  }

  void _goToProfile() => setState(() => _currentIndex = 3);

  void _updatePosition(LatLng position) => setState(() => _position = position);

  @override
  Widget build(BuildContext context) {
    final screens = [
      ExplorerScreen(
        position: _position,
        isOnline: _isOnline,
        savedPlacesCount: _savedPlacesCount,
        onOpenDetail: _openDetail,
        onOpenProfile: _goToProfile,
      ),
      NearbyScreen(
        position: _position,
        locationService: _locationService,
        onPositionUpdated: _updatePosition,
      ),
      AlertsScreen(position: _position),
      ProfileScreen(
        notificationService: _notificationService,
        onOpenDetail: _openDetail,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
