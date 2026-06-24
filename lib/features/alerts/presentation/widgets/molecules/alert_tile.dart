import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';
import 'package:geo_notif_offline/features/alerts/domain/alert_item.dart';

class AlertTile extends StatelessWidget {
  final AlertItem alert;

  const AlertTile({super.key, required this.alert});

  Color get _accentColor {
    switch (alert.type) {
      case AlertType.proximity:
        return AppColors.accent;
      case AlertType.saved:
        return AppColors.violet;
      case AlertType.weatherRisk:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: kCardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(alert.icon, size: 18, color: _accentColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(alert.message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(alert.relativeTime, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
