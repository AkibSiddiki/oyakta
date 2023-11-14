import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:oyakta/src/services/background_task.dart';
import 'package:oyakta/src/services/coordinate_to_address.dart';
import 'package:oyakta/src/services/get_oyakta.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OyaktaProviders extends ChangeNotifier {
  late LocationData selectedPosition;
  late double latitude;
  late double longitude;
  late String locality;
  late PrayerTimes prayerTimesOfSelectedLocation;
  late List<DateTime> prayerTimes;
  late DateTime today = DateTime.now();
  double compassDir = 0.0;
  double qiblaDir = 0.0;
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
    getQiblaDirection();
    final prefs = await SharedPreferences.getInstance();
    final String? selectLocality = prefs.getString('locality');
    final double? selectedPositionLat = prefs.getDouble('selectedPositionLat');
    final double? selectedPositionLong =
        prefs.getDouble('selectedPositionLong');
    if (selectedPositionLat == null ||
        selectedPositionLong == null ||
        selectLocality == null) {
      await getCurrentLocation();
      await getOyakta();
    } else {
      latitude = selectedPositionLat;
      longitude = selectedPositionLong;
      locality = selectLocality;
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
      // bool serviceEnabled;
      // LocationPermission permission;

      // permission = await Geolocator.checkPermission();
      // if (permission == LocationPermission.denied) {
      //   permission = await Geolocator.requestPermission();
      //   if (permission == LocationPermission.denied) {
      //     reqComplete = true;
      //     notifyListeners();
      //     throw Exception('Location permissions are denied');
      //   }
      // }

      // if (permission == LocationPermission.deniedForever) {
      //   reqComplete = true;
      //   notifyListeners();
      //   throw Exception(
      //       'Location permissions are permanently denied, we cannot request permissions.');
      // }

      // serviceEnabled = await Geolocator.isLocationServiceEnabled();

      // if (!serviceEnabled) {
      //   reqComplete = true;
      //   notifyListeners();
      //   Geolocator.openLocationSettings();
      //   throw Exception('Location services are disabled.');
      // }

      // selectedPosition = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.low);

      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          reqComplete = true;
          notifyListeners();
          throw Exception('Location services are disabled.');
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          reqComplete = true;
          notifyListeners();
          throw Exception('Location permissions are denied');
        }
      }
      await location.changeSettings(accuracy: LocationAccuracy.low);
      selectedPosition = await location.getLocation();

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('selectedPositionLat', selectedPosition.latitude!);
      await prefs.setDouble(
          'selectedPositionLong', selectedPosition.longitude!);

      latitude = selectedPosition.latitude!;
      longitude = selectedPosition.longitude!;
      notifyListeners();

      locality = (await getAddress(latitude, longitude)) ?? 'N/A';
      await prefs.setString('locality', locality);
      notifyListeners();

      await getOyakta();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getOyakta() async {
    reqComplete = false;
    notifyListeners();
    prayerTimesOfSelectedLocation = await getAdhan(latitude, longitude, today);

    reqComplete = true;
    notifyListeners();
  }

  Future<void> toggleAlert(String prayerName) async {
    final prefs = await SharedPreferences.getInstance();
    if (alerts[prayerName] == false) {
      alerts[prayerName] = true;
      await prefs.setBool(prayerName, alerts[prayerName]!);
      notifyListeners();
      backgroundTask();
    } else {
      alerts[prayerName] = false;
      notifyListeners();
      await prefs.setBool(prayerName, alerts[prayerName]!);
      backgroundTask();
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

  Stream<void> getCompassDirection() async* {
    final CompassEvent tmp = await FlutterCompass.events!.first;
    compassDir = tmp.heading!;
    notifyListeners();
    // ignore: avoid_print
    print(compassDir);
    await Future.delayed(
        const Duration(milliseconds: 300)); // Wait for one second
  }

  Future<void> getQiblaDirection() async {
    qiblaDir = Qibla.qibla(Coordinates(latitude, longitude));
    notifyListeners();
  }
}
