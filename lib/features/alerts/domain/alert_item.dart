import 'package:flutter/cupertino.dart';

enum AlertType { proximity, saved, weatherRisk }

class AlertItem {
  final AlertType type;
  final String title;
  final String message;
  final DateTime time;

  const AlertItem({
    required this.type,
    required this.title,
    required this.message,
    required this.time,
  });

  IconData get icon {
    switch (type) {
      case AlertType.proximity:
        return CupertinoIcons.location;
      case AlertType.saved:
        return CupertinoIcons.cloud_download;
      case AlertType.weatherRisk:
        return CupertinoIcons.exclamationmark_triangle;
    }
  }

  String get relativeTime {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    if (diff.inDays < 2) return 'Hier';
    return '${diff.inDays} j';
  }

  bool get isToday {
    final now = DateTime.now();
    return now.difference(time).inDays < 1 && now.day == time.day;
  }
}
