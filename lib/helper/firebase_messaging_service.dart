import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'app_string.dart';
import 'app_message.dart';
import 'single_app.dart';

class FirebaseMessagingService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize FlutterLocalNotificationsPlugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@drawable/ic_launcher'); // Replace with your icon name
    // const IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings();
    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // No `onDidReceiveLocalNotification` in the latest version
      notificationCategories: [
        DarwinNotificationCategory(
          'category_id',
          actions: [
            DarwinNotificationAction.plain(
              'action_id',
              'Action Title',
            ),
          ],
        ),
      ],
    );

    // DarwinInitializationSettings initializationSettingsIOS =
    //     DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    //   onDidReceiveLocalNotification:
    //       (int id, String? title, String? body, String? payload) async {},
    // );
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request notification permissions
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      sound: true,
    );

    // Handle incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received message in foreground: $message');
      flutterLocalNotificationsPlugin.show(
        DateTime.now().hashCode,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // Replace with your channel ID
            'channel_name', // Replace with your channel name
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
      );
    });

    // Handle initial message when the app is cold launched
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      appLog('Received message on app launch: $initialMessage');
      _handleMessage(
          initialMessage); // Define your handling logic for the initial message
    }

    // Handle background messages (Android only)
    if (Platform.isAndroid) {
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        appLog('Received message when app was background: $message');
        _handleMessage(
            message); // Define your handling logic for background messages (Android)
      });
    }

    // Subscribe to topic(s) if needed (optional)
    // await FirebaseMessaging.instance.subscribeToTopic('your_topic');

    // Handle token refresh (optional)
    FirebaseMessaging.instance.getToken().then((token) async {
      appLog('Push Notification Token: $token');
      final MyApplication misApp = Get.find<MyApplication>();
      if (misApp.preferenceHelper != null) {
        await misApp.preferenceHelper!.setString(fbEidKey, token ?? '');
      }
    }).catchError((error) {
      appLog('Error getting push notification token: $error');
    });
  }

  void _handleMessage(RemoteMessage message) {
    // Handle notification data payload, navigate to screens, etc.
    // Example:
    final String title = message.notification!.title!;
    final String body = message.notification!.body!;
    appLog('Notification title: $title, body: $body');
  }
}
