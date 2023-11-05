// ignore_for_file: avoid_print
import 'package:prayers_times/prayers_times.dart';

Future<PrayerTimes> getAdhan(double lat, double long, DateTime today) async {
  Coordinates coordinates = Coordinates(lat, long);

  PrayerCalculationParameters params = PrayerCalculationMethod.ummAlQura();
  params.madhab = PrayerMadhab.hanafi;

  PrayerTimes prayerTimes = PrayerTimes(
      coordinates: coordinates,
      calculationParameters: params,
      locationName: convertTimeZoneOffsetToName(DateTime.now().timeZoneName),
      dateTime: today);

  print(
      "---Today's Prayer Times in Your Local Timezone(${prayerTimes.locationName})---");
  print('Fajr Start Time:\t${prayerTimes.fajrStartTime!}');
  print('Fajr End Time:\t${prayerTimes.fajrEndTime!}');
  print('Sunrise Time:\t${prayerTimes.sunrise!}');
  print('Dhuhr Start Time:\t${prayerTimes.dhuhrStartTime!}');
  print('Dhuhr End Time:\t${prayerTimes.dhuhrEndTime!}');
  print('Asr Start Time:\t${prayerTimes.asrStartTime!}');
  print('Asr End Time:\t${prayerTimes.asrEndTime!}');
  print('Maghrib Start Time:\t${prayerTimes.maghribStartTime!}');
  print('Maghrib End Time:\t${prayerTimes.maghribEndTime!}');
  print('Isha Start Time:\t${prayerTimes.ishaStartTime!}');
  print('Isha End Time:\t${prayerTimes.ishaEndTime!}');

  String current = prayerTimes.currentPrayer();
  String next = prayerTimes.nextPrayer();
  print('\n***** Convenience Utilities');
  print('Current Prayer:\t$current\t${prayerTimes.timeForPrayer(current)}');
  print('Next Prayer:\t$next\t${prayerTimes.timeForPrayer(next)}');

  print('---');

  return prayerTimes;
}

String convertTimeZoneOffsetToName(String offset) {
  return timeZoneOffsetToName[offset] ?? "Unknown";
}

Map<String, String> timeZoneOffsetToName = {
  "-12": "Etc/GMT+12",
  "-11": "Pacific/Pago_Pago",
  "-10": "Pacific/Honolulu",
  "-09": "America/Anchorage",
  "-08": "America/Los_Angeles",
  "-07": "America/Denver",
  "-06": "America/Chicago",
  "-05": "America/New_York",
  "-04": "America/Caracas",
  "-03.5": "America/St_Johns",
  "-03": "America/Argentina/Buenos_Aires",
  "-02": "Atlantic/South_Georgia",
  "-01": "Atlantic/Azores",
  "+00": "Etc/GMT",
  "+01": "Europe/Paris",
  "+02": "Africa/Cairo",
  "+03": "Asia/Riyadh",
  "+03.5": "Asia/Tehran",
  "+04": "Asia/Dubai",
  "+04.5": "Asia/Kabul",
  "+05": "Asia/Karachi",
  "+05.5": "Asia/Kolkata",
  "+05.75": "Asia/Kathmandu",
  "+06": "Asia/Almaty",
  "+06.5": "Indian/Cocos",
  "+07": "Asia/Bangkok",
  "+08": "Asia/Singapore",
  "+09": "Asia/Tokyo",
  "+09.5": "Australia/Adelaide",
  "+10": "Australia/Sydney",
  "+11": "Pacific/Guadalcanal",
  "+12": "Pacific/Fiji",
  "+13": "Pacific/Tongatapu",
  "+14": "Pacific/Kiritimati"
};
