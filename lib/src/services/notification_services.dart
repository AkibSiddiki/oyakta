import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oyakta/src/services/get_oyakta.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  // notificationDetails() {
  //   return const NotificationDetails(
  //       android: AndroidNotificationDetails('channelId', 'channelName',
  //           importance: Importance.max),
  //       iOS: DarwinNotificationDetails());
  // }

  // Future showNotification(
  //     {int id = 0, String? title, String? body, String? payLoad}) async {
  //   return notificationsPlugin.show(
  //       id, title, body, await notificationDetails());
  // }

  void cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<void> schaduleNotification(
      String title, String body, DateTime prayertime) async {
    tz.initializeTimeZones();
    tz.TZDateTime tzPrayertime = tz.TZDateTime.from(
        prayertime,
        tz.getLocation(
            convertTimeZoneOffsetToName(DateTime.now().timeZoneName)));
    return await notificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tzPrayertime,
        NotificationDetails(
            android: AndroidNotificationDetails(
                'prayer_time_id_$title', 'prayer_time_channel',
                channelDescription: 'Prayer Time')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}