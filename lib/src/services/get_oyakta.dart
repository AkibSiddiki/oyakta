// ignore_for_file: avoid_print
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

PrayerTimes getAdhan(Position p) {
  final myCoordinates = Coordinates(p.latitude, p.longitude);
  final params = CalculationMethod.umm_al_qura.getParameters();
  params.madhab = Madhab.hanafi;
  final prayerTimes = PrayerTimes.today(myCoordinates, params);

  print(
      "---Today's Prayer Times in Your Local Timezone(${prayerTimes.fajr.timeZoneName})---");
  print(DateFormat.jm().format(prayerTimes.fajr));
  print(DateFormat.jm().format(prayerTimes.sunrise));
  print(DateFormat.jm().format(prayerTimes.dhuhr));
  print(DateFormat.jm().format(prayerTimes.asr));
  print(DateFormat.jm().format(prayerTimes.maghrib));
  print(DateFormat.jm().format(prayerTimes.isha));

  print('---');

  return prayerTimes;
}
