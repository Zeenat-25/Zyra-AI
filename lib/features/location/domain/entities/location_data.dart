class LocationData {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final double? speed;
  final String? address;
  final DateTime timestamp;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.speed,
    this.address,
    required this.timestamp,
  });
}
