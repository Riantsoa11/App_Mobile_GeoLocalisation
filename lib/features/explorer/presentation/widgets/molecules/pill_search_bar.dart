import 'package:flutter/cupertino.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';

/// iOS-style search field: flat grey rounded rect, magnifier glyph, no
/// shadow/border (matches UIKit's UISearchBar look).
class PillSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onSubmitted;
  final TextEditingController? controller;

  const PillSearchBar({
    super.key,
    required this.hint,
    required this.onSubmitted,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      placeholder: hint,
      placeholderStyle: const TextStyle(color: AppColors.textSecondary),
      style: const TextStyle(color: AppColors.textPrimary),
      prefix: const Padding(
        padding: EdgeInsets.only(left: 12),
        child: Icon(CupertinoIcons.search, color: AppColors.textSecondary, size: 20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.searchFill,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
