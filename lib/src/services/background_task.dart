import 'package:oyakta/src/services/get_oyakta.dart';
import 'package:oyakta/src/services/notification_services.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> backgroundTask() async {
  final prefs = await SharedPreferences.getInstance();
  bool fajrA = prefs.getBool('fajr') ?? false;
  bool dhuhrA = prefs.getBool('dhuhr') ?? false;
  bool asrA = prefs.getBool('asr') ?? false;
  bool maghribA = prefs.getBool('maghrib') ?? false;
  bool ishaA = prefs.getBool('isha') ?? false;

  final double? selectedPositionLat = prefs.getDouble('selectedPositionLat');
  final double? selectedPositionLong = prefs.getDouble('selectedPositionLong');

  if (selectedPositionLat != null || selectedPositionLong != null) {
    PrayerTimes prayertime = await getAdhan(
        selectedPositionLat!, selectedPositionLong!, DateTime.now());

    NotificationService notif = NotificationService();
    notif.initNotification();
    notif.cancelAllNotifications();

    if (fajrA != false && prayertime.fajrStartTime != null) {
      notif.schaduleNotification(
          'Fajr', 'Prayer Time', prayertime.fajrStartTime ?? DateTime.now());
    }
    if (dhuhrA != false && prayertime.dhuhrStartTime != null) {
      notif.schaduleNotification(
          'Dhuhr', 'Prayer Time', prayertime.dhuhrStartTime ?? DateTime.now());
    }
    if (asrA != false && prayertime.dhuhrStartTime != null) {
      notif.schaduleNotification(
          'Asr', 'Prayer Time', prayertime.asrStartTime!);
    }
    if (maghribA != false && prayertime.maghribStartTime != null) {
      notif.schaduleNotification(
          'Maghrib', 'Prayer Time', prayertime.maghribStartTime!);
    }
    if (ishaA != false && prayertime.ishaStartTime != null) {
      notif.schaduleNotification(
          'Isha', 'Prayer Time', prayertime.ishaStartTime ?? DateTime.now());
    }
  }
}
