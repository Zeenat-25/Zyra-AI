class Contact {
  final int? id;
  final int userId;
  final String name;
  final String phone;
  final String? email;
  final String? relationship;
  final bool isEmergencyContact;
  final String createdAt;

  const Contact({
    this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.email,
    this.relationship,
    this.isEmergencyContact = false,
    required this.createdAt,
  });

  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? relationship,
    bool? isEmergencyContact,
  }) {
    return Contact(
      id: id ?? this.id,
      userId: userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      relationship: relationship ?? this.relationship,
      isEmergencyContact: isEmergencyContact ?? this.isEmergencyContact,
      createdAt: createdAt,
    );
  }
}
