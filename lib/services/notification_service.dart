import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _notifications.initialize(initializationSettings);
  }

  static Future<void> showBudgetExceededNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'budget_channel',
      'Budget Notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);
    await _notifications.show(
      0,
      'Attention !',
      'Vous avez dépassé votre budget.',
      notificationDetails,
    );
  }
}