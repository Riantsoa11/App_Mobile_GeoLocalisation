import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';
import 'package:geo_notif_offline/features/shell/presentation/app_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orbe',
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}
