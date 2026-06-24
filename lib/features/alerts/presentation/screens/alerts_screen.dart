import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';
import 'package:geo_notif_offline/core/widgets/atoms/section_label.dart';
import 'package:geo_notif_offline/features/alerts/domain/alert_item.dart';
import 'package:geo_notif_offline/features/alerts/domain/alerts_service.dart';
import 'package:geo_notif_offline/features/alerts/presentation/widgets/molecules/alert_tile.dart';
import 'package:latlong2/latlong.dart';

class AlertsScreen extends StatefulWidget {
  final LatLng? position;

  const AlertsScreen({super.key, required this.position});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final _alertsService = AlertsService();
  List<AlertItem> _alerts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(AlertsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final alerts = await _alertsService.build(widget.position);
    if (!mounted) return;
    setState(() {
      _alerts = alerts;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = _alerts.where((a) => a.isToday).toList();
    final earlier = _alerts.where((a) => !a.isToday).toList();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Alertes', style: Theme.of(context).textTheme.headlineMedium),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _alerts.isEmpty ? null : () => setState(() => _alerts = []),
                  child: const Text('Tout lire'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CupertinoActivityIndicator()),
              )
            else if (_alerts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text('Aucune alerte pour le moment.', style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else ...[
              if (today.isNotEmpty) ...[
                const SectionLabel(text: "Aujourd'hui"),
                const SizedBox(height: 10),
                ...today.map((a) => AlertTile(alert: a)),
                const SizedBox(height: 20),
              ],
              if (earlier.isNotEmpty) ...[
                const SectionLabel(text: 'Cette semaine'),
                const SizedBox(height: 10),
                ...earlier.map((a) => AlertTile(alert: a)),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
