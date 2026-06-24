import 'package:flutter/cupertino.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: active ? AppColors.accent.withValues(alpha: 0.15) : AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: kCardShadow,
        ),
        child: Icon(icon, color: active ? AppColors.accentDark : AppColors.textPrimary),
      ),
    );
  }
}
