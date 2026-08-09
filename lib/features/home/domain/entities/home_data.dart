class HomeData {
  final String greeting;
  final bool isSosActive;
  final int emergencyContactsCount;
  final String? lastLocation;
  final bool voiceDetectionEnabled;

  const HomeData({
    required this.greeting,
    this.isSosActive = false,
    this.emergencyContactsCount = 0,
    this.lastLocation,
    this.voiceDetectionEnabled = false,
  });
}
