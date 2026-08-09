import 'package:geolocator/geolocator.dart';
import 'package:zyra/core/errors/failures.dart';

class LocationDataSource {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationFailure('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationFailure('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationFailure('Location permission permanently denied');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Stream<Position> trackPosition({required int intervalMs}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(milliseconds: intervalMs),
      ),
    );
  }

  Future<List<Placemark>> getPlacemarks(double lat, double lng) async {
    return Geolocator.placemarkFromCoordinates(lat, lng);
  }
}
