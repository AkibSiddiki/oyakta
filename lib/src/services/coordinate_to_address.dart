import 'package:geocoding/geocoding.dart';

Future<String?> getAddress(double lat, double long) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

  var first = placemarks.first;
  return first.locality;
}
