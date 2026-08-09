import 'package:geolocator/geolocator.dart';
import '../errors/failures.dart';

class LocationService {
  static Future<Position> getCurrentLocation() async {
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
        distanceFilter: 10,
      ),
    );
  }

  static Stream<Position> trackLocation({
    int intervalMs = 30000,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter.toDouble(),
        timeLimit: Duration(milliseconds: intervalMs),
      ),
    );
  }

  static Future<double> getDistanceBetween(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  static Future<String> getAddressFromCoordinates(
    double latitude, double longitude,
  ) async {
    try {
      final placemarks = await Geolocator.placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return '${placemark.street ?? ""}, ${placemark.locality ?? ""}, ${placemark.country ?? ""}';
      }
      return 'Unknown location';
    } catch (e) {
      return '$latitude, $longitude';
    }
  }
}
