import 'package:zyra/features/sos/domain/entities/sos_alert.dart';

class SosAlertModel extends SosAlert {
  const SosAlertModel({
    super.id,
    required super.userId,
    super.latitude,
    super.longitude,
    required super.triggerType,
    super.status,
    required super.createdAt,
    super.resolvedAt,
  });

  factory SosAlertModel.fromMap(Map<String, dynamic> map) {
    return SosAlertModel(
      id: map['id'] as int,
      userId: map['userId'] as int,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      triggerType: map['triggerType'] as String,
      status: map['status'] as String? ?? 'active',
      createdAt: map['createdAt'] as String,
      resolvedAt: map['resolvedAt'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'triggerType': triggerType,
      'status': status,
      'createdAt': createdAt,
      'resolvedAt': resolvedAt,
    };
  }
}
