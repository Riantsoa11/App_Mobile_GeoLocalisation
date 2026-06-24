import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFFAF9F6);
  static const surface = Color(0xFFFFFFFF);
  static const accent = Color(0xFF1FA9A0);
  static const accentDark = Color(0xFF128A82);
  static const textPrimary = Color(0xFF1B2430);
  static const textSecondary = Color(0xFF6B7785);
  static const danger = Color(0xFFE2654B);
  static const warning = Color(0xFFE0A930);
  static const violet = Color(0xFF8B7CF6);
  static const pink = Color(0xFFE3789E);
  static const green = Color(0xFF4CAF7D);
  static const blueAccent = Color(0xFF4C8BF5);
  static const searchFill = Color(0xFFEEEBE4);
}

const kSectionLabelStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.5,
  color: AppColors.accentDark,
);

final kCardShadow = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

/// iOS-style hairline separator color (matches UIKit's default separator).
const kHairline = Color(0x33000000);

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
    ).copyWith(primary: AppColors.accent, surface: AppColors.surface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimary),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      // iOS-style slide transition on every platform, including page-edge
      // swipe-to-go-back, for pushes done with the default MaterialPageRoute.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
