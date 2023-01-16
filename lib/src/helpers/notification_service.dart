import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initializeNotifications() {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (_) {
      return;
    });
  }

  static void showNotification(Map<String, dynamic> message) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'SMN_Chef', //Required for Android 8.0 or after
            'notification Channel', //Required for Android 8.0 or after
            'notification Channel Description', //Required for Android 8.0 or after
            playSound: true,
            channelShowBadge: true,
            enableLights: true,
            showWhen: true,
            ticker: 'ticker',
            enableVibration: true,
            importance: Importance.max,
            priority: Priority.high);

    final IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
      presentAlert:
          true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      //sound: 'String',  // Specifics the file path to play (only from iOS 10 onwards)
      //badgeNumber: int?, // The application's icon badge number
      // attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
      // subtitle: String?, //Secondary description  (only from iOS 10 onwards)
      // threadIdentifier: String? (only from iOS 10 onwards)
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        message['notification']['title'],
        message['notification']['body'],
        platformChannelSpecifics,
        payload: 'data');
  }

  Future selectNotification(String payload) async {
    //Handle notification tapped logic here
  }
}
