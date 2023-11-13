import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oyakta/src/services/get_oyakta.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    _configureLocalTimeZone();
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

  // DateTime pastDateToFutureDate(DateTime dt) {
  //   if (dt.isBefore(DateTime.now())) {
  //     dt = dt.add(const Duration(days: 1));
  //   }

  //   return dt;
  // }

  /// Set right date and time for notifications
  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz
        .getLocation(convertTimeZoneOffsetToName(DateTime.now().timeZoneName)));
  }

  void cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<void> schaduleNotification(
      String title, String body, DateTime prayertime, int id) async {
    return await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _convertTime(prayertime.hour, prayertime.minute),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'prayer_time_id', 'prayer_time_channel',
                channelDescription: 'Prayer Time',
                playSound: true,
                sound: RawResourceAndroidNotificationSound(
                  'allah_u_akbar',
                ),
                enableLights: true,
                importance: Importance.high)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
