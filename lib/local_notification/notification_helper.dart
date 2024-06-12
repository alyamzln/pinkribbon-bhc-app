import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future init({bool scheduled = false}) async {
    // Request permissions for notifications
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    var initAndroidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = DarwinInitializationSettings();
    final settings =
        InitializationSettings(android: initAndroidSettings, iOS: ios);
    await _notification.initialize(settings);
  }

  static Future showNotification({
    var id = 0,
    var title,
    var body,
    var payload,
  }) async {
    var notificationDetails = await _notificationDetails();
    await _notification.show(id, title, body, notificationDetails);
  }

  static Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'important_notifications', // channel ID
      'Important Notifications', // channel name
      channelDescription:
          'This channel is used for important notifications.', // channel description
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }

  static Future scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    var androidDetails = const AndroidNotificationDetails(
      'important_notifications',
      'My Channel',
      channelDescription: 'Channel for important notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    tz.initializeTimeZones();

    await _notification.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
