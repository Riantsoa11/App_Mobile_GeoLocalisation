import 'package:flutter/cupertino.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOnline;
  final int savedPlacesCount;

  const OfflineBanner({
    super.key,
    required this.isOnline,
    required this.savedPlacesCount,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnline && savedPlacesCount == 0) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.cloud_download,
            color: AppColors.accentDark,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isOnline
                  ? '$savedPlacesCount lieu${savedPlacesCount > 1 ? 'x' : ''} disponible${savedPlacesCount > 1 ? 's' : ''} hors-ligne'
                  : 'Mode hors-ligne actif — $savedPlacesCount lieu${savedPlacesCount > 1 ? 'x' : ''} disponible${savedPlacesCount > 1 ? 's' : ''}',
              style: const TextStyle(
                color: AppColors.accentDark,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
