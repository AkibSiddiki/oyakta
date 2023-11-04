import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oyakta/src/services/coordinate_to_address.dart';
import 'package:oyakta/src/services/get_oyakta.dart';

class OyaktaProviders extends ChangeNotifier {
  late Position currentPosition;
  late Placemark currentPlacemark;
  late PrayerTimes prayerTimesOfCurrentLocation;
  bool reqComplete = false;

  Future<void> getOyakta() async {
    reqComplete = false;
    notifyListeners();
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        Geolocator.openLocationSettings();
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      currentPlacemark = await getAddress(currentPosition);
      prayerTimesOfCurrentLocation = getAdhan(currentPosition);

      reqComplete = true;
      notifyListeners();
    } catch (e) {
      // print('Error in getOyakta: $e');

      reqComplete = false;
      notifyListeners();
    }
  }
}
