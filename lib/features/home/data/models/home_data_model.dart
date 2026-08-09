import 'package:zyra/features/home/domain/entities/home_data.dart';

class HomeDataModel extends HomeData {
  const HomeDataModel({
    required super.greeting,
    super.isSosActive,
    super.emergencyContactsCount,
    super.lastLocation,
    super.voiceDetectionEnabled,
  });

  factory HomeDataModel.fromMap(Map<String, dynamic> map) {
    return HomeDataModel(
      greeting: map['greeting'] as String? ?? 'Welcome',
      isSosActive: map['isSosActive'] as bool? ?? false,
      emergencyContactsCount: map['emergencyContactsCount'] as int? ?? 0,
      lastLocation: map['lastLocation'] as String?,
      voiceDetectionEnabled: map['voiceDetectionEnabled'] as bool? ?? false,
    );
  }
}
