import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/models/place.dart';
import 'package:geo_notif_offline/core/services/notification_service.dart';
import 'package:geo_notif_offline/core/services/offline_cache_service.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';
import 'package:geo_notif_offline/core/widgets/atoms/section_label.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatefulWidget {
  final NotificationService notificationService;
  final ValueChanged<Place> onOpenDetail;

  const ProfileScreen({
    super.key,
    required this.notificationService,
    required this.onOpenDetail,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _cacheService = OfflineCacheService();

  PackageInfo? _packageInfo;
  LocationPermission? _locationPermission;
  List<Bookmark> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      PackageInfo.fromPlatform(),
      Geolocator.checkPermission(),
      _cacheService.getBookmarks(),
    ]);
    if (!mounted) return;
    setState(() {
      _packageInfo = results[0] as PackageInfo;
      _locationPermission = results[1] as LocationPermission;
      _bookmarks = results[2] as List<Bookmark>;
    });
  }

  Future<void> _removeBookmark(Place place) async {
    await _cacheService.removeBookmark(place);
    _load();
  }

  String get _locationLabel {
    switch (_locationPermission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return 'Autorisee';
      case LocationPermission.denied:
        return 'Refusee';
      case LocationPermission.deniedForever:
        return 'Bloquee';
      default:
        return 'Inconnue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Text('Profil', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              boxShadow: kCardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel(text: 'Application'),
                const SizedBox(height: 10),
                _InfoRow(label: 'Version', value: _packageInfo == null
                    ? '—'
                    : '${_packageInfo!.version}+${_packageInfo!.buildNumber}'),
                const SizedBox(height: 8),
                _InfoRow(label: 'Localisation', value: _locationLabel),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              boxShadow: kCardShadow,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Tester les notifications', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(999),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  onPressed: () => widget.notificationService.show(
                    title: 'Orbe',
                    body: 'Ceci est une notification de test.',
                  ),
                  child: const Text('Envoyer'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionLabel(text: 'Lieux sauvegardes hors-ligne'),
          const SizedBox(height: 12),
          if (_bookmarks.isEmpty)
            const Text(
              'Aucun lieu sauvegarde. Ouvrez un lieu et appuyez sur le marque-page pour le garder hors-ligne.',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            ..._bookmarks.map(
              (bookmark) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: kCardShadow,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => widget.onOpenDetail(bookmark.place),
                        child: Text(bookmark.place.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () => _removeBookmark(bookmark.place),
                      child: const Icon(CupertinoIcons.delete, color: AppColors.textSecondary, size: 20),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
