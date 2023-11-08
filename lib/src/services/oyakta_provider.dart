import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oyakta/src/services/coordinate_to_address.dart';
import 'package:oyakta/src/services/get_oyakta.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OyaktaProviders extends ChangeNotifier {
  late Position selectedPosition;
  late double latitude;
  late double longitude;
  late Placemark selectedPlacemark;
  late PrayerTimes prayerTimesOfSelectedLocation;
  late List<DateTime> prayerTimes;
  late DateTime today = DateTime.now();
  bool reqComplete = false;

  Map<String, bool> alerts = {
    'fajr': false,
    'dhuhr': false,
    'asr': false,
    'maghrib': false,
    'isha': false,
  };

  Future<void> initOyakta() async {
    await initAlert();
    final prefs = await SharedPreferences.getInstance();
    final double? selectedPositionLat = prefs.getDouble('selectedPositionLat');
    final double? selectedPositionLong =
        prefs.getDouble('selectedPositionLong');
    if (selectedPositionLat == null || selectedPositionLong == null) {
      await getCurrentLocation();
      await getOyakta();
    } else {
      latitude = selectedPositionLat;
      longitude = selectedPositionLong;
      notifyListeners();
      await getOyakta();
    }
  }

  void nextDate() {
    today = today.add(const Duration(days: 1));
    notifyListeners();
    getOyakta();
  }

  void prevDate() {
    today = today.subtract(const Duration(days: 1));
    notifyListeners();
    getOyakta();
  }

  void resetDate() {
    if (today != DateTime.now()) {
      today = DateTime.now();
      notifyListeners();
      getOyakta();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          reqComplete = true;
          notifyListeners();
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        reqComplete = true;
        notifyListeners();
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        reqComplete = true;
        notifyListeners();
        // Geolocator.openLocationSettings();
        throw Exception('Location services are disabled.');
      }

      selectedPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      notifyListeners();
      // print(selectedPosition);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('selectedPositionLat', selectedPosition.latitude);
      await prefs.setDouble('selectedPositionLong', selectedPosition.longitude);

      latitude = selectedPosition.latitude;
      longitude = selectedPosition.longitude;
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () async {
        await getOyakta();
      });
      // ignore: empty_catches
    } catch (e) {
      print(e);
    }
  }

  Future<void> getOyakta() async {
    reqComplete = false;
    notifyListeners();

    selectedPlacemark = await getAddress(latitude, longitude);
    notifyListeners();
    prayerTimesOfSelectedLocation = await getAdhan(latitude, longitude, today);

    reqComplete = true;
    notifyListeners();
  }

  Future<void> toggleAlert(String prayerName) async {
    final prefs = await SharedPreferences.getInstance();
    if (alerts[prayerName] == false) {
      alerts[prayerName] = true;
      notifyListeners();
      await prefs.setBool(prayerName, alerts[prayerName]!);
    } else {
      alerts[prayerName] = false;
      notifyListeners();
      await prefs.setBool(prayerName, alerts[prayerName]!);
    }
  }

  Future<void> initAlert() async {
    final prefs = await SharedPreferences.getInstance();
    alerts['fajr'] = (prefs.getBool('fajr')) ?? false;
    alerts['dhuhr'] = (prefs.getBool('dhuhr')) ?? false;
    alerts['asr'] = (prefs.getBool('asr')) ?? false;
    alerts['maghrib'] = (prefs.getBool('maghrib')) ?? false;
    alerts['isha'] = (prefs.getBool('isha')) ?? false;
    notifyListeners();
  }
}
