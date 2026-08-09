import 'package:flutter_test/flutter_test.dart';
import 'package:zyra/features/contacts/data/models/contact_model.dart';

void main() {
  group('ContactModel', () {
    test('fromMap creates ContactModel correctly', () {
      final map = {
        'id': 1,
        'userId': 1,
        'name': 'Emergency Contact',
        'phone': '+1234567890',
        'email': 'emergency@example.com',
        'relationship': 'Spouse',
        'isEmergencyContact': 1,
        'createdAt': '2024-01-01T00:00:00.000',
      };

      final contact = ContactModel.fromMap(map);
      expect(contact.name, 'Emergency Contact');
      expect(contact.phone, '+1234567890');
      expect(contact.isEmergencyContact, true);
    });

    test('toMap converts correctly', () {
      final contact = ContactModel(
        userId: 1,
        name: 'Test Contact',
        phone: '+1111111111',
        isEmergencyContact: true,
        createdAt: '2024-01-01T00:00:00.000',
      );

      final map = contact.toMap();
      expect(map['name'], 'Test Contact');
      expect(map['isEmergencyContact'], 1);
    });
  });
}
