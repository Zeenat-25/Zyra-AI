class SosAlert {
  final int? id;
  final int userId;
  final double? latitude;
  final double? longitude;
  final String triggerType;
  final String status;
  final String createdAt;
  final String? resolvedAt;

  const SosAlert({
    this.id,
    required this.userId,
    this.latitude,
    this.longitude,
    required this.triggerType,
    this.status = 'active',
    required this.createdAt,
    this.resolvedAt,
  });

  SosAlert copyWith({String? status, String? resolvedAt}) {
    return SosAlert(
      id: id,
      userId: userId,
      latitude: latitude,
      longitude: longitude,
      triggerType: triggerType,
      status: status ?? this.status,
      createdAt: createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
