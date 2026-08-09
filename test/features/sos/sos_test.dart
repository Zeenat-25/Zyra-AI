import 'package:flutter_test/flutter_test.dart';
import 'package:zyra/features/sos/data/models/sos_alert_model.dart';

void main() {
  group('SosAlertModel', () {
    test('fromMap creates SosAlertModel correctly', () {
      final map = {
        'id': 1,
        'userId': 1,
        'latitude': 40.7128,
        'longitude': -74.0060,
        'triggerType': 'manual_button',
        'status': 'active',
        'createdAt': '2024-01-01T00:00:00.000',
      };

      final alert = SosAlertModel.fromMap(map);
      expect(alert.userId, 1);
      expect(alert.triggerType, 'manual_button');
      expect(alert.status, 'active');
    });

    test('toMap converts correctly', () {
      final alert = SosAlertModel(
        userId: 1,
        triggerType: 'voice_help',
        createdAt: '2024-01-01T00:00:00.000',
      );

      final map = alert.toMap();
      expect(map['triggerType'], 'voice_help');
      expect(map['status'], 'active');
    });
  });
}
