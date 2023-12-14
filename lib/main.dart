import 'package:flutter/material.dart';
import 'package:oyakta/src/services/background_task.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workmanager/workmanager.dart';
import 'package:oyakta/src/screens/home.dart';
import 'package:oyakta/src/screens/compass.dart';
import 'package:oyakta/src/screens/splash_screen.dart';
import 'package:oyakta/src/services/oyakta_provider.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await backgroundTask();
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Workmanager().registerPeriodicTask("task_id", "backgroundTask",
      frequency: const Duration(minutes: 5));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OyaktaProviders())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const Home(),
          '/qibla': (context) => const Compass(),
        },
      ),
    );
  }
}

// Future<void> backgroundTask() async {
//   final prefs = await SharedPreferences.getInstance();
//   bool fajrA = prefs.getBool('fajr') ?? false;
//   bool dhuhrA = prefs.getBool('dhuhr') ?? false;
//   bool asrA = prefs.getBool('asr') ?? false;
//   bool maghribA = prefs.getBool('maghrib') ?? false;
//   bool ishaA = prefs.getBool('isha') ?? false;

//   final double? selectedPositionLat = prefs.getDouble('selectedPositionLat');
//   final double? selectedPositionLong = prefs.getDouble('selectedPositionLong');

//   if (selectedPositionLat != null || selectedPositionLong != null) {
//     PrayerTimes prayertime = await getAdhan(
//         selectedPositionLat!, selectedPositionLong!, DateTime.now());

//     NotificationService notif = NotificationService();
//     notif.initNotification();
//     notif.cancelAllNotifications();

//     if (fajrA != false && prayertime.fajrStartTime != null) {
//       notif.schaduleNotification(
//           'Fajr', 'Prayer Time', prayertime.fajrStartTime!, 1);
//     }
//     if (dhuhrA != false && prayertime.dhuhrStartTime != null) {
//       notif.schaduleNotification(
//           'Dhuhr', 'Prayer Time', prayertime.dhuhrStartTime!, 2);
//     }
//     if (asrA != false && prayertime.dhuhrStartTime != null) {
//       notif.schaduleNotification(
//           'Asr', 'Prayer Time', prayertime.asrStartTime!, 3);
//     }
//     if (maghribA != false && prayertime.maghribStartTime != null) {
//       notif.schaduleNotification(
//           'Maghrib', 'Prayer Time', prayertime.maghribStartTime!, 4);
//     }
//     if (ishaA != false && prayertime.ishaStartTime != null) {
//       notif.schaduleNotification(
//           'Isha', 'Prayer Time', prayertime.ishaStartTime!, 5);
//     }
//   }
// }

// Future<PrayerTimes> getAdhan(double lat, double long, DateTime today) async {
//   Coordinates coordinates = Coordinates(lat, long);
//   PrayerCalculationParameters params = PrayerCalculationMethod.ummAlQura();
//   params.madhab = PrayerMadhab.hanafi;

//   PrayerTimes prayerTimes = PrayerTimes(
//       coordinates: coordinates,
//       calculationParameters: params,
//       locationName: convertTimeZoneOffsetToName(DateTime.now().timeZoneName),
//       dateTime: today);
//   return prayerTimes;
// }

// String convertTimeZoneOffsetToName(String offset) {
//   return timeZoneOffsetToName[offset] ?? "Unknown";
// }

// Map<String, String> timeZoneOffsetToName = {
//   "-12": "Etc/GMT+12",
//   "-11": "Pacific/Pago_Pago",
//   "-10": "Pacific/Honolulu",
//   "-09": "America/Anchorage",
//   "-08": "America/Los_Angeles",
//   "-07": "America/Denver",
//   "-06": "America/Chicago",
//   "-05": "America/New_York",
//   "-04": "America/Caracas",
//   "-03.5": "America/St_Johns",
//   "-03": "America/Argentina/Buenos_Aires",
//   "-02": "Atlantic/South_Georgia",
//   "-01": "Atlantic/Azores",
//   "+00": "Etc/GMT",
//   "+01": "Europe/Paris",
//   "+02": "Africa/Cairo",
//   "+03": "Asia/Riyadh",
//   "+03.5": "Asia/Tehran",
//   "+04": "Asia/Dubai",
//   "+04.5": "Asia/Kabul",
//   "+05": "Asia/Karachi",
//   "+05.5": "Asia/Kolkata",
//   "+05.75": "Asia/Kathmandu",
//   "+06": "Asia/Almaty",
//   "+06.5": "Indian/Cocos",
//   "+07": "Asia/Bangkok",
//   "+08": "Asia/Singapore",
//   "+09": "Asia/Tokyo",
//   "+09.5": "Australia/Adelaide",
//   "+10": "Australia/Sydney",
//   "+11": "Pacific/Guadalcanal",
//   "+12": "Pacific/Fiji",
//   "+13": "Pacific/Tongatapu",
//   "+14": "Pacific/Kiritimati"
// };

// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     _configureLocalTimeZone();
//     notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .requestNotificationsPermission();

//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('icon');

//     var initializationSettingsIOS = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification:
//             (int id, String? title, String? body, String? payload) async {});

//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {});
//   }

//   /// Set right date and time for notifications
//   tz.TZDateTime _convertTime(int hour, int minutes) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduleDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minutes,
//     );
//     if (scheduleDate.isBefore(now)) {
//       scheduleDate = scheduleDate.add(const Duration(days: 1));
//     }
//     return scheduleDate;
//   }

//   Future<void> _configureLocalTimeZone() async {
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz
//         .getLocation(convertTimeZoneOffsetToName(DateTime.now().timeZoneName)));
//   }

//   void cancelAllNotifications() async {
//     await notificationsPlugin.cancelAll();
//   }

//   Future<void> schaduleNotification(
//       String title, String body, DateTime prayertime, int id) async {
//     return await notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         _convertTime(prayertime.hour, prayertime.minute),
//         // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'prayer_time_id', 'prayer_time_channel',
//                 channelDescription: 'Prayer Time',
//                 playSound: true,
//                 sound: RawResourceAndroidNotificationSound(
//                   'allah_u_akbar',
//                 ),
//                 enableLights: true,
//                 importance: Importance.high)),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime);
//   }
// }
