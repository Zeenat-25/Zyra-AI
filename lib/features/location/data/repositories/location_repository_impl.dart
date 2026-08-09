import 'package:zyra/features/location/domain/entities/location_data.dart';
import 'package:zyra/features/location/domain/repositories/location_repository.dart';
import '../datasources/location_datasource.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _dataSource;

  LocationRepositoryImpl(this._dataSource);

  @override
  Future<LocationData> getCurrentLocation() async {
    final position = await _dataSource.getCurrentPosition();
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      accuracy: position.accuracy,
      speed: position.speed,
      timestamp: DateTime.now(),
    );
  }

  @override
  Stream<LocationData> trackLocation({int intervalMs = 30000}) {
    return _dataSource.trackPosition(intervalMs: intervalMs).map(
      (position) => LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
        speed: position.speed,
        timestamp: DateTime.now(),
      ) as LocationData,
    );
  }

  @override
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await _dataSource.getPlacemarks(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return '${p.street ?? ""}, ${p.locality ?? ""}, ${p.country ?? ""}';
      }
      return '$lat, $lng';
    } catch (e) {
      return '$lat, $lng';
    }
  }
}
