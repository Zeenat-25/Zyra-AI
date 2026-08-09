import 'package:zyra/features/location/domain/entities/location_data.dart';

class LocationModel extends LocationData {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    super.altitude,
    super.accuracy,
    super.speed,
    super.address,
    required super.timestamp,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      altitude: (map['altitude'] as num?)?.toDouble(),
      accuracy: (map['accuracy'] as num?)?.toDouble(),
      speed: (map['speed'] as num?)?.toDouble(),
      address: map['address'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'accuracy': accuracy,
      'speed': speed,
      'address': address,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
