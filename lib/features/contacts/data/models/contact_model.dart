import 'package:zyra/features/contacts/domain/entities/contact.dart';

class ContactModel extends Contact {
  const ContactModel({
    super.id,
    required super.userId,
    required super.name,
    required super.phone,
    super.email,
    super.relationship,
    super.isEmergencyContact,
    required super.createdAt,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as int,
      userId: map['userId'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String?,
      relationship: map['relationship'] as String?,
      isEmergencyContact: (map['isEmergencyContact'] as int) == 1,
      createdAt: map['createdAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'relationship': relationship,
      'isEmergencyContact': isEmergencyContact ? 1 : 0,
      'createdAt': createdAt,
    };
  }
}
