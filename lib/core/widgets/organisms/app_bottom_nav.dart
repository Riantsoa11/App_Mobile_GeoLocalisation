import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';

/// iOS-style flush tab bar: translucent blur background, hairline top
/// border, SF Symbols-style icons, no Material ripple/elevation.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (icon: CupertinoIcons.globe, label: 'Globe'),
    (icon: CupertinoIcons.location_circle, label: 'Autour'),
    (icon: CupertinoIcons.bell, label: 'Alertes'),
    (icon: CupertinoIcons.person_crop_circle, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.only(
            top: 8,
            bottom: 8 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.82),
            border: const Border(top: BorderSide(color: kHairline, width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_items.length, (index) {
              final selected = index == currentIndex;
              final item = _items[index];
              final color = selected ? AppColors.accent : AppColors.textSecondary;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon, color: color, size: 24),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
