import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Placemark> getAddress(Position p) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(p.latitude, p.longitude);

  var first = placemarks.first;
  return first;
}
