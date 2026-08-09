import 'package:flutter_test/flutter_test.dart';
import 'package:zyra/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromMap creates UserModel correctly', () {
      final map = {
        'id': 1,
        'name': 'John Doe',
        'email': 'john@example.com',
        'phone': '+1234567890',
        'createdAt': '2024-01-01T00:00:00.000',
      };

      final user = UserModel.fromMap(map);
      expect(user.id, 1);
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phone, '+1234567890');
    });

    test('toMap converts correctly', () {
      final user = UserModel(
        id: 1,
        name: 'Jane Doe',
        email: 'jane@example.com',
        phone: '+9876543210',
        createdAt: '2024-01-01T00:00:00.000',
      );

      final map = user.toMap();
      expect(map['name'], 'Jane Doe');
      expect(map['email'], 'jane@example.com');
    });
  });
}
