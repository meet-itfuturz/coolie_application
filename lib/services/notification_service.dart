import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }

  void showRemoteNotificationAndroid(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? apple = message.notification?.apple;
    if (notification != null) {
      NotificationDetails notificationDetails = NotificationDetails(
        android: android != null
            ? const AndroidNotificationDetails(
                "tasks_event",
                "Tasks Event",
                ticker: 'ticker',
                showWhen: true,
                playSound: true,
                enableLights: true,
                enableVibration: true,
                priority: Priority.high,
                importance: Importance.max,
                visibility: NotificationVisibility.public,
                channelDescription: "The event reminder system for planora user to manage events_history",
              )
            : null,
        iOS: apple != null ? const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true) : null,
      );
      await flutterLocalNotificationsPlugin.show(notification.hashCode, notification.title, notification.body, notificationDetails);
    }
  }

  Future<String?> getToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      if (Platform.isIOS) {
        String? fcmToken = await FirebaseMessaging.instance.getAPNSToken();
        return fcmToken;
      } else {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        return fcmToken;
      }
    } catch (err) {
      return null;
    }
  }
}

NotificationService notificationService = NotificationService();
