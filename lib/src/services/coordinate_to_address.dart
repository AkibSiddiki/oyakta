import 'package:geocoding/geocoding.dart';

Future<Placemark> getAddress(double lat, double long) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

  var first = placemarks.first;
  return first;
}
