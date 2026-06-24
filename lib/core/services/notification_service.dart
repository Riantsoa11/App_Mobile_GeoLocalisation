import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> show({required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      'alerts_channel',
      'Alertes Orbe',
      channelDescription: 'Notifications de proximite, meteo et hors-ligne',
      importance: Importance.max,
      priority: Priority.high,
    );
    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(android: androidDetails),
    );
  }
}
