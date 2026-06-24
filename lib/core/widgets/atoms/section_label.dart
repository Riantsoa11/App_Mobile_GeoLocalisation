import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  final IconData? icon;

  const SectionLabel({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: AppColors.accentDark),
          const SizedBox(width: 6),
        ],
        Text(text.toUpperCase(), style: kSectionLabelStyle),
      ],
    );
  }
}
