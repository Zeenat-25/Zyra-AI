import 'package:zyra/core/errors/failures.dart';
import '../entities/location_data.dart';

abstract class LocationRepository {
  Future<LocationData> getCurrentLocation();
  Stream<LocationData> trackLocation({int intervalMs = 30000});
  Future<String> getAddressFromCoordinates(double lat, double lng);
}
